//
//  ChatMessageScrollView.swift
//  ChatBot
//
//  Created by Appscrip 3Embed on 31/08/24.
//

import SwiftUI
import Combine

struct ChatMessageScrollView: View {
    
    // MARK: - PROPERTIES
    @Environment(\.customScheme) var colorScheme
    @ObservedObject var viewModel: ChatViewModel
    @Namespace var bottomId
    
    @State var showWelcomeView: Bool = false
    @FocusState.Binding var isFocused: Bool
    
    var suggestedReplyAction: ((String)->Void)?
    var widgetAction: ((ChatBotWidget?,WidgetType)->Void)?
    var widgetResponseAction: ((String?)->Void)?
    var widgetViewAllResponseAction: ((String?, GptClientResponseModel? , [String]? , WidgetType)->Void)?
    
    // MARK: - BODY
    
    var body: some View {
        ZStack {
            ScrollViewReader { proxy in
                ScrollView {
                    if viewModel.myGptSessionData != nil, showWelcomeView {
                        WelcomeView(
                            chatBotName: viewModel.myGptSessionData?.data?.first?.name ?? "",
                            appTheme: viewModel.appConfigurations.appTheme,
                            myGptSessionData: viewModel.myGptSessionData,
                            uiPreference: viewModel.myGptSessionData?.data?.first?.uiPreferences,
                            hideSuggestedReplies: $viewModel.hideSuggestedReplies
                        ) { suggestedReply in
                            suggestedReplyAction?(suggestedReply)
                            viewModel.hideSuggestedReplies = true
                        }
                    }
                    VStack {
                        ForEach(viewModel.messages) { message in
                            MessageView(
                                appTheme: viewModel.appConfigurations.appTheme,
                                message: message,
                                chatBotImageUrl: viewModel.myGptSessionData?.data?.first?.profileImage ?? "",
                                gptUIPreference: viewModel.myGptSessionData?.data?.first?.uiPreferences,
                                widgetAction: { widget, type in
                                    widgetAction?(widget, type)
                                },
                                widgetResponseAction: { reply in
                                    widgetResponseAction?(reply)
                                },
                                widgetViewAllResponseAction: { (title, widgetData, options, widgetType) in
                                    widgetViewAllResponseAction?(title, widgetData, options, widgetType)
                                }
                            )
                                .transition(.push(from: .bottom))
                                .animation(.easeInOut, value: viewModel.messages)
                        }
                        Spacer().id(bottomId)
                    }
                }
                .scrollIndicators(.hidden)
                .customContentMargins(top: 10, bottom: 10)
                .onTapGesture {
                    isFocused = false
                }
                .onAppear {
                    scrollToBottom(proxy: proxy)
                }
                .onChange(of: viewModel.messages.last?.text) { _ in
                    // Scroll to the bottom whenever the messages are updated
                    scrollToBottom(proxy: proxy)
                    viewModel.hideSuggestedReplies = viewModel.messages.isEmpty ? false : true
                }
            }
        }//: ZSTACK
        .background(viewModel.appConfigurations.appTheme.theme.colors.secondaryBackgroundColor(for: colorScheme))
        .onAppear {
            showWelcomeView = true
        }
    }//: BODY
    
    // MARK: - FUNCTIONS
    
    func scrollToBottom(proxy: ScrollViewProxy) {
        withAnimation {
            proxy.scrollTo(bottomId, anchor: .bottom)
        }
    }
    
}
