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
                appTheme: viewModel.appConfigurations.appTheme,
                leadingButtonAction: {
                    dismiss_callback?()
                    dismiss()
                },
                trailingButtonAction: {
                    showAlertForResetingSession = true
                }
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
        .alert("Are you sure want a reset?", isPresented: $showAlertForResetingSession) {
            Button("Reset", role: .destructive) {
                viewModel.resetSession()
            }
            Button("Cancel", role: .cancel){}
        } message: {
            Text("This will reset your conversation which cannot be recovered later.")
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
