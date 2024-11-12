//
//  FloatingView.swift
//  ChatBot
//
//  Created by Appscrip 3Embed on 11/11/24.
//

import SwiftUI

public struct FloatingView: View {
    
    // MARK: - PROPERTIES
    
    @State private var colorScheme: AppColorScheme = .dark
    @StateObject public var viewModel: LaunchViewModel
    @State private var isLoading: Bool = true
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    @State private var viewAppeared = false
    
    public init(viewModel: LaunchViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var combinedBottomPadding: CGFloat {
        let tabBarHeight = UIApplication.shared.windows.first?.rootViewController?.tabBarController?.tabBar.frame.height ?? 0
        let bottomInset = UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0
        return tabBarHeight + bottomInset + 16  // Adding 16 for additional spacing
    }
    
    // MARK: - BODY
    
    public var body: some View {
        ZStack(alignment: .bottom) {
            Color.black
                .opacity(0.6)
                .ignoresSafeArea(.all)
                .opacity(viewAppeared ? 1 : 0)
                .onTapGesture {
                    // Dismiss when tapping outside the button
                    ISMChatBotUserDefaultsManager.setValue(true, forKey: ISMChatBotUserDefaultKey.userInteractedWithChatBot.rawValue)
                    dismissHostingController(animated: false) {
                        DispatchQueue.main.async {
                            viewModel.floatingViewDismissedWithoutAction?()
                        }
                    }
                }
            VStack(alignment: .trailing, spacing: 0) {
                if viewModel.myGptSessionData != nil {
                    // welcome message bubble
                    viewModel.appConfigurations.appTheme.theme.images.welcomeBot
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150)
                        .offset(y: 35)
                        .scaleEffect(x: -1, y: 1, anchor: .center)
                        .clipped()
                    VStack(alignment: .leading) {
                        Text("Meet \(viewModel.myGptSessionData?.data?.first?.name ?? "")")
                            .foregroundColor(.white)
                            .font(.system(size: 16, weight: .bold))
                        Text(viewModel.myGptSessionData?.data?.first?.welcomeMessage?.first ?? "Welcome, what would you like to order today ?")
                            .foregroundColor(.white)
                            .font(.system(size: 14))
                    }
                    .padding(12)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [Color(hex: "#2E8AFF"), Color(hex: "#93EDAB")]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                        .clipShape(RoundedCorner(topLeft: 8, topRight: 8, bottomLeft: 8, bottomRight: 0))
                    )
                    .offset(y: viewAppeared ? 0 : 20) // Scale animation
                    .opacity(viewAppeared ? 1 : 0) // Fade-in animation
                    
                    if let suggestedMessages = viewModel.myGptSessionData?.data?.first?.suggestedReplies {
                        SuggestedRepliesView(
                            replies: suggestedMessages,
                            uiPreference: viewModel.myGptSessionData?.data?.first?.uiPreferences,
                            alignment: .trailing,
                            backgroundColor: .white
                        ){ reply in
                            ISMChatBotUserDefaultsManager.setValue(true, forKey: ISMChatBotUserDefaultKey.userInteractedWithChatBot.rawValue)
                            
                            // navigate action
                            dismissHostingController(animated: false) {
                                DispatchQueue.main.async {
                                    viewModel.withReply = reply
                                    viewModel.floatingActionCallback?()
                                }
                            }
                        }
                        .offset(y: viewAppeared ? 0 : 20) // Scale animation
                        .opacity(viewAppeared ? 1 : 0)
                    }
                }
                HStack {
                    Spacer()
                    Button {
                        ISMChatBotUserDefaultsManager.setValue(true, forKey: ISMChatBotUserDefaultKey.userInteractedWithChatBot.rawValue)
                        
                        // navigate action
                        dismissHostingController(animated: false) {
                            DispatchQueue.main.async {
                                viewModel.withReply = nil
                                viewModel.floatingActionCallback?()
                            }
                        }
                        
                    } label: {
                        ZStack {
                            Circle()
                                .fill(colorScheme == .dark ? Color.white.opacity(0.1) : Color.black.opacity(0.1))
                                .frame(width: 80, height: 80)
                            URLImageView(url: URL(string: viewModel.myGptSessionData?.data?.first?.profileImage ?? "") ?? URL(string: "https://i.sstatic.net/frlIf.png"))
                                .scaledToFill()
                                .frame(width: 80, height: 80)
                                .clipped()
                                .cornerRadius(40)
                        }
                    }
                    .buttonStyle(AnimatedButtonStyle())
                    .offset(y: viewAppeared ? 0 : 20) // Scale animation
                    .opacity(viewAppeared ? 1 : 0)
                }
                .padding(.top, 12)
                .padding(.bottom, combinedBottomPadding)
            }
            .padding(.horizontal, 16)
        }
        .opacity((viewModel.myGptSessionData != nil) ? 1 : 0)
        .alert("Error", isPresented: $showAlert) {
            Button("cancel", role: .cancel) {}
            Button("Try again", role: .none) {
                fetchGptsContent()
            }
        } message: {
            Text(alertMessage)
        }
        .onAppear {
            fetchGptsContent()
        }
    }
    
    // MARK: - FUNCTIONS
    
    private func fetchGptsContent() {
        Task {
            do {
                isLoading = true
                try await viewModel.getMyGptsContent()
                HapticFeedbackManager.shared.triggerNotification(type: .success)
                
                withAnimation(.smooth(duration: 0.4)) {
                    viewAppeared = true // Trigger animation after data fetch
                }
                
            } catch {
                // Handle the error here
                isLoading = false
                alertMessage = "Failed to get content: \(error.localizedDescription)"
                showAlert = true
                HapticFeedbackManager.shared.triggerNotification(type: .error)
            }
        }
    }
    
}
