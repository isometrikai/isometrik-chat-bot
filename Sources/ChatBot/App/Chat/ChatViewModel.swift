//
//  ChatViewModel.swift
//  ChatBot
//
//  Created by Appscrip 3Embed on 23/08/24.
//

import Foundation
import CryptoKit

protocol ChatExternalDelegate {
    func didWidgetTapped(withData: Widget?)
}

public class ChatViewModel: ObservableObject {
    
    // MARK: - PROPERTIES
    
    private let apiService: ChatAPIService
    private var networkMiddleware: NetworkMiddleware
    var delegate: ChatExternalDelegate?
    var myGptSessionData: MyGptsResponseModel?
    var sessionId: String
    private var sendMessageTask: Task<(), Never>?
    
    @Published var messages: [CustomMessageModel] = []
    @Published var isTyping: Bool = false
    @Published var appConfigurations: AppConfigurationManager
    
    // MARK: - INITIALIZER
    
    init(
        apiService: ChatAPIService,
        appConfig: AppConfigurationManager,
        delegate: ChatExternalDelegate? = nil,
        myGptSessionData: MyGptsResponseModel? = nil,
        sessionId: String = "\(Int(Date().timeIntervalSince1970))"
    ) {
        self.apiService = apiService
        self.myGptSessionData = myGptSessionData
        self.delegate = delegate
        self.appConfigurations = appConfig
        self.networkMiddleware = NetworkMiddleware(appConfig: appConfig)
        
        // Hashing the sessionId to make it even more unique
        let inputData = Data(sessionId.utf8)
        let hashedSessionId = SHA256.hash(data: inputData)
        self.sessionId = hashedSessionId.compactMap { String(format: "%02x", $0) }.joined()
        
    }
    
    // MARK: - METHODS
    
    func sendMessage(message: String) {
        
        // Cancel any ongoing request before starting a new one
        sendMessageTask?.cancel()

        // add the message to the list
        messages.append(CustomMessageModel(text: message, isFromUser: true))
        
        sendMessageTask = Task {
            do {
                let parameters = GPTClientRequestParameters(
                    chatBotId: 188,
                    message: message,
                    sessionId: sessionId,
                    storeCategoryId: appConfigurations.storeCategoryId,
                    userId: appConfigurations.userId
                )
                
                let data = try await networkMiddleware.performRequest {
                    return try await self.apiService.gptClientMsg(requestParameter: parameters)
                }
                
                if !Task.isCancelled {
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
    
}
