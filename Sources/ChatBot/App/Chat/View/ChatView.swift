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
    var dismiss_callback: (()->Void)?
    
    @State private var showDismissPopup = false
    @State private var showAlertForResetingSession: Bool = false
    
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
                chatBotName: viewModel.myGptSessionData?.data?.first?.name ?? "ChatBot",
                chatBotImageUrl: viewModel.myGptSessionData?.data?.first?.profileImage ?? "",
                appTheme: viewModel.appConfigurations.appTheme,
                leadingButtonAction: handleLeadingAction,
                trailingButtonAction: handleTrailingAction
            )
            ChatMessageScrollView(
                viewModel: viewModel,
                isFocused: $isFocused,
                suggestedReplyAction: sendMessage,
                widgetAction: handleWidgetAction
            )
            MessageToolBarView(
                isFocused: $isFocused,
                isBotTyping: $viewModel.isTyping,
                appTheme: viewModel.appConfigurations.appTheme,
                sendAction: sendMessage,
                cancelAction: cancelSendMessage
            )
        }//: VSTACK
        .navigationBarHidden(true)
        .onAppear {
            isFocused = true
        }
        .onChange(of: showDismissPopup) { newValue in
            if newValue {
                PopupManager.shared.showPopup(
                    title: "Exit Chat",
                    message: "You will lose your current chat context. Are you sure you want to exit?",
                    animationType: .slideInBottom,
                    actions: [
                        PopupAction(title: "cancel".uppercased(), buttonType: .cancel , handler: {
                            showDismissPopup = false
                        }),
                        PopupAction(title: "exit chat".uppercased(), buttonType: .destructive , handler: {
                            dismiss_callback?()
                            dismiss()
                        })
                    ]
                )
            }
        }
        .onChange(of: showAlertForResetingSession) { newValue in
            if newValue {
                PopupManager.shared.showPopup(
                    title: "Are you sure want to start new chat?",
                    message: "",
                    animationType: .slideInBottom,
                    actions: [
                        PopupAction(title: "cancel".uppercased(), buttonType: .cancel , handler: {
                            showAlertForResetingSession = false
                        }),
                        PopupAction(title: "yes".uppercased(), buttonType: ._default , handler: {
                            viewModel.resetSession()
                        })
                    ]
                )
            }
        }
    }
    
    // MARK: - FUNTION
    
    private func handleLeadingAction() {
        HapticFeedbackManager.shared.triggerSelection()
        if !viewModel.messages.isEmpty {
            isFocused = false
            showDismissPopup = true
        } else {
            dismiss_callback?()
            dismiss()
        }
    }
    
    private func handleTrailingAction() {
        HapticFeedbackManager.shared.triggerNotification(type: .warning)
        isFocused = false
        showAlertForResetingSession = true
    }
    
    private func sendMessage(message: String) {
        self.sendMessageWithBotChanges(message: message)
        HapticFeedbackManager.shared.triggerSelection()
    }
    
    private func cancelSendMessage() {
        viewModel.cancelSendMessage()
        HapticFeedbackManager.shared.triggerNotification(type: .error)
    }
    
    private func handleWidgetAction(widget: ChatBotWidget?) {
        viewModel.delegate?.navigateFromBot(withData: widget, forType: .store, dismissOnSuccess: { success in
            dismiss_callback?()
            dismiss()
        })
        HapticFeedbackManager.shared.triggerSelection()
    }
    
    func sendMessageWithBotChanges(message: String) {
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
