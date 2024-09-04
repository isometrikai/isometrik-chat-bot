//
//  ChatView.swift
//  ChatBot
//
//  Created by Appscrip 3Embed on 23/08/24.
//

import SwiftUI

public enum CustomField {
    case messageInput
}

struct ChatView: View {
    
    // MARK: - PROPERTIES
    
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel: ChatViewModel
    @FocusState var isFocused: Bool
    
    // MARK: - BODY
    
    var body: some View {
        VStack(spacing: 0) {
            CustomNavView(
                appTheme: viewModel.appConfigurations.appTheme,
                leadingButtonAction: { dismiss() }
            )
            ChatMessageScrollView(
                viewModel: viewModel,
                isFocused: $isFocused,
                suggestedReplyAction: { replyMessage  in
                    sendMessage(message: replyMessage)
                },
                widgetAction: { widget in
                    viewModel.delegate?.navigateFromBot(withData: widget, forType: .dish)
                }
            )
            MessageToolBarView(
                isFocused: $isFocused,
                isBotTyping: $viewModel.isTyping,
                appTheme: viewModel.appConfigurations.appTheme,
                sendAction: { message in
                    sendMessage(message: message)
                },
                cancelAction: {
                    viewModel.cancelSendMessage()
                }
            )
        }//: VSTACK
        .navigationBarHidden(true)
        .onAppear {
            isFocused = true
        }
    }
    
    // MARK: - FUNTION
    
    func sendMessage(message: String) {
        if !message.isEmpty {
            withAnimation(.easeInOut) {
                viewModel.sendMessage(message: message)
            }
            
            // Simulate bot response after a delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation(.easeInOut) {
                    viewModel.messages.append(CustomMessageModel())
                }
            }
        }
    }
    
}
