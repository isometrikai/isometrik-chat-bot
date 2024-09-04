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
    
    @ObservedObject var viewModel: ChatViewModel
    @Namespace var bottomId
    
    @State var showWelcomeView: Bool = false
    @State private var scrollProxy: ScrollViewProxy?
    @FocusState.Binding var isFocused: Bool
    
    var suggestedReplyAction: ((String)->Void)?
    var widgetAction: ((ChatBotWidget?)->Void)?
    
    
    // MARK: - BODY
    
    var body: some View {
        
        ZStack {
            ScrollViewReader { proxy in
                ScrollView {
                    if viewModel.myGptSessionData != nil, showWelcomeView {
                        WelcomeView(
                            appTheme: viewModel.appConfigurations.appTheme,
                            myGptSessionData: viewModel.myGptSessionData,
                            uiPreference: viewModel.myGptSessionData?.data?.first?.uiPreferences
                        ) { suggestedReply in
                            suggestedReplyAction?(suggestedReply)
                        }
                        .transition(.push(from: .leading))
                        .animation(.smooth, value: viewModel.messages)
                    }
                    VStack {
                        ForEach(viewModel.messages) { message in
                            MessageView(
                                appTheme: viewModel.appConfigurations.appTheme,
                                message: message,
                                gptUIPreference: viewModel.myGptSessionData?.data?.first?.uiPreferences,
                                widgetAction: { widget in
                                    widgetAction?(widget)
                                }
                            )
                                .transition(.push(from: .bottom))
                                .animation(.easeInOut, value: viewModel.messages)
                        }
                        Spacer().id(bottomId)
                    }
                }
                .background(Color.white)
                .scrollIndicators(.hidden)
                .modifier(ContentMarginsModifier())
                .scrollToBottom(
                    value: viewModel.messages.last?.text ?? "",
                    isFocused: isFocused,
                    bottomId: bottomId,
                    proxy: $scrollProxy
                )
                .onTapGesture {
                    isFocused = false
                }
                .onAppear {
                    scrollProxy = proxy
                }
            }
        }//: ZSTACK
        .onAppear {
            // Delay the appearance of WelcomeView
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { // Adjust the delay as needed
                withAnimation(.smooth) {
                    showWelcomeView = true
                }
            }
        }
        
    }
    
}

fileprivate struct ContentMarginsModifier: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 17.0, *) {
            content
                .contentMargins(.top, 10, for: .scrollContent)
        } else {
            content
                .padding(.top, 10)
        }
    }
}
