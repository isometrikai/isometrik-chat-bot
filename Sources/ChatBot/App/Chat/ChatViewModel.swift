//
//  ChatViewModel.swift
//  ChatBot
//
//  Created by Appscrip 3Embed on 23/08/24.
//

import Foundation
import CryptoKit
import UIKit

enum WidgetType: String {
    case cardView = "stores"
    case responseView = "options"
    
}

public protocol ChatBotDelegate {
    func navigateFromBot(withData: ChatBotWidget?, dismissOnSuccess: @escaping (Bool)->())
}

@MainActor
public class ChatViewModel: ObservableObject {
    
    // MARK: - PROPERTIES
    
    private let apiService: ChatAPIService
    private var networkMiddleware: NetworkMiddleware
    var delegate: ChatBotDelegate?
    var myGptSessionData: MyGptsResponseModel?
    var sessionId: String
    var withReply: String?
    private var sendMessageTask: Task<(), Never>?
    
    @Published var messages: [CustomMessageModel] = []
    @Published var isTyping: Bool = false
    @Published var appConfigurations: AppConfigurationManager
    @Published var hideSuggestedReplies: Bool = false
    
    var widgetResponseSheetTitle: String = ""
    var widgetResponseOptions: [ChatBotWidget] = []
    var widgetOptions: [String] = []
    
    // MARK: - INITIALIZER
    
    init(
        apiService: ChatAPIService,
        appConfig: AppConfigurationManager,
        delegate: ChatBotDelegate? = nil,
        myGptSessionData: MyGptsResponseModel? = nil,
        sessionId: String = "\(Int(Date().timeIntervalSince1970))",
        withReply: String? = nil
    ) {
        self.apiService = apiService
        self.myGptSessionData = myGptSessionData
        self.delegate = delegate
        self.appConfigurations = appConfig
        self.networkMiddleware = NetworkMiddleware(appConfig: appConfig)
        self.sessionId = ChatViewModel.getHashedSessionId(id: sessionId)
        self.withReply = withReply
    }
    
    // MARK: - METHODS
    
    func sendMessage(message: String) {
        
        // Cancel any ongoing request before starting a new one
        sendMessageTask?.cancel()

        // add the message to the list
        self.messages.append(CustomMessageModel(text: message, isFromUser: true))
        
        
        sendMessageTask = Task {
            do {
                // Agent identifier provided by the backend service
                // This is used to associate actions with the current agent
                let agentId = "67a9df239dbfc422720f19b5"
                
                let parameters = GPTClientRequestParameters(
                    chatBotId: Int(appConfigurations.chatBotId) ?? 0,
                    message: message,
                    sessionId: sessionId,
                    storeCategoryId: appConfigurations.storeCategoryId,
                    userId: appConfigurations.userId,
                    location: appConfigurations.location,
                    longitude: "\(appConfigurations.longitude)",
                    latitude: "\(appConfigurations.latitude)",
                    isLoggedIn: false,
                    fingerPrintId: UIDevice.current.identifierForVendor?.uuidString ?? "Unknown",
                    agentId: agentId
                )
                
                let data = try await networkMiddleware.performRequest {
                    return try await self.apiService.gptClientMsg(requestParameter: parameters)
                }
                
                if !Task.isCancelled {
                    HapticFeedbackManager.shared.triggerNotification(type: .success)
                    DispatchQueue.main.async {
                        let lastMessageIndex = self.messages.count - 1
                        self.messages[lastMessageIndex].text = data.text ?? ""
                        self.messages[lastMessageIndex].isResponding = false
                        self.messages[lastMessageIndex].messageData = data
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        if self.messages.last?.text == data.text {
                            self.isTyping = false
                        }
                    }
                }
            } catch {
                if !Task.isCancelled {
                    self.isTyping = false
                    DispatchQueue.main.async {
                        let lastMessageIndex = self.messages.count - 1
                        self.messages[lastMessageIndex].text = "Something went wrong, try again!"
                        self.messages[lastMessageIndex].isResponding = false
                    }
                    print(#file + #function + error.localizedDescription)
                }
            }
        }
        
        // for showing indicator
        isTyping = true
        
    }
    
    func cancelSendMessage() {
        sendMessageTask?.cancel()
        isTyping = false

        // messages on cancel response from bot
        let messages = [
            "Got a new craving? Let me know what you're thinking!",
            "Ready for more recommendations, or is there something else on your mind?",
            "If you have something else in mind, just type the word!",
            "Want to explore other options or chat about something else? I'm here for it!",
            "If there's something different you're curious about, feel free to ask!"
        ]

        // Pick a random message
        let randomMessage = messages.randomElement() ?? "Looking for something else? I'm all ears!"

        DispatchQueue.main.async {
            let lastMessageIndex = self.messages.count - 1
            self.messages[lastMessageIndex].text = randomMessage
            self.messages[lastMessageIndex].isResponding = false
        }
    }
    
    func resetSession() {
        // Clear messages
        self.messages.removeAll()
        
        // Reset session-related properties
        self.sessionId = ChatViewModel.getHashedSessionId(id: "\(Int(Date().timeIntervalSince1970))")

        // Cancel any ongoing message sending tasks
        sendMessageTask?.cancel()
        sendMessageTask = nil
        
        // Reset typing status
        self.isTyping = false
        
        // reset the suggestion hidden status
        self.hideSuggestedReplies = false
    }
    
    func removeWidgetResponseViewOnReply(){
        DispatchQueue.main.async {
            let lastMessageIndex = self.messages.count - 1
            self.messages[lastMessageIndex].messageData?.widgetData?[0].repliedStatusToSuggestions = true
        }
    }
    
    private static func getHashedSessionId(id: String) -> String {
        let inputData = Data(id.utf8)
        let hashedSessionId = SHA256.hash(data: inputData)
        return hashedSessionId.compactMap { String(format: "%02x", $0) }.joined()
    }
}
