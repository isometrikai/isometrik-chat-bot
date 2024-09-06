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
    @State private var showAlertForResetingSession: Bool = false
    @FocusState var isFocused: Bool
    var dismiss_callback: (()->Void)?
    
    private var isTrailingActionEnabled: Binding<Bool> {
        Binding(
            get: { !viewModel.messages.isEmpty },
            set: { _ in } // No-op for the setter, as we don't need to write to this Binding
        )
    }
    
    // MARK: - BODY
    
    var body: some View {
        VStack(spacing: 0) {
            CustomNavView(
                isLeadingActionEnabled: .constant(true), 
                isTrailingActionEnabled: isTrailingActionEnabled,
                chatBotName: viewModel.appConfigurations.chatBotName,
                appTheme: viewModel.appConfigurations.appTheme,
                leadingButtonAction: {
                    HapticFeedbackManager.shared.triggerSelection()
                    dismiss_callback?()
                    dismiss()
                },
                trailingButtonAction: {
                    showAlertForResetingSession = true
                    HapticFeedbackManager.shared.triggerNotification(type: .warning)
                }
            )
            ChatMessageScrollView(
                viewModel: viewModel,
                isFocused: $isFocused,
                suggestedReplyAction: { replyMessage  in
                    sendMessage(message: replyMessage)
                    HapticFeedbackManager.shared.triggerSelection()
                },
                widgetAction: { widget in
                    viewModel.delegate?.navigateFromBot(withData: widget, forType: .store)
                    HapticFeedbackManager.shared.triggerSelection()
                }
            )
            MessageToolBarView(
                isFocused: $isFocused,
                isBotTyping: $viewModel.isTyping,
                appTheme: viewModel.appConfigurations.appTheme,
                sendAction: { message in
                    sendMessage(message: message)
                    HapticFeedbackManager.shared.triggerSelection()
                },
                cancelAction: {
                    viewModel.cancelSendMessage()
                    HapticFeedbackManager.shared.triggerNotification(type: .error)
                }
            )
        }//: VSTACK
        .navigationBarHidden(true)
        .onAppear {
            isFocused = true
        }
        .alert("Are you sure want to start new chat?", isPresented: $showAlertForResetingSession) {
            Button("Yes", role: .destructive) {
                viewModel.resetSession()
            }
            Button("Cancel", role: .cancel){}
        } message: {
            Text("")
        }
    }
    
    // MARK: - FUNTION
    
    func sendMessage(message: String) {
        if !message.isEmpty {
            
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                withAnimation(.easeInOut) {
                    viewModel.sendMessage(message: message)
                }
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
