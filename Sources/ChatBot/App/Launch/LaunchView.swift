//
//  LaunchView.swift
//  ChatBot
//
//  Created by Appscrip 3Embed on 23/08/24.
//

import SwiftUI

public struct LaunchView: View {
    
    // MARK: - PROPERTIES
    
    @State private var colorScheme: AppColorScheme = .dark
    @StateObject public var viewModel: LaunchViewModel
    @State private var scaleEffect: Bool = false
    @State private var isLoading: Bool = true
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    @State private var navigateToChatView = false
    
    public init(viewModel: LaunchViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    // MARK: - BODY
    
    public var body: some View {
        NavigationStack {
            ZStack(alignment: .center){
                Rectangle()
                    .fill(viewModel.appConfigurations.appTheme.theme.colors.primaryBackgroundColor(for: colorScheme))
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    if isLoading {
                        LoaderView(colorScheme: colorScheme, appConfig: viewModel.appConfigurations)
                    } else {
                        NavigationLink(value: navigateToChatView) {
                            viewModel.appConfigurations.appTheme.theme.images.appLogo
                                .resizable()
                                .scaledToFill()
                                .frame(width: 70, height: 70)
                                .scaleEffect(scaleEffect ? 1.2 : 1)
                                .animation(.easeOut(duration: 2).repeatForever(autoreverses: true), value: scaleEffect)
                        }
                        .padding()
                        .buttonStyle(AnimatedButtonStyle())
                    }
                }
            }
            .navigationBarHidden(true)
            .onAppear {
                scaleEffect = true
            }
            .navigationDestination(isPresented: $navigateToChatView) {
                
                let chatViewModel = ChatViewModel(
                    apiService: ChatNetworkService(),
                    appConfig: viewModel.appConfigurations,
                    delegate: self,
                    myGptSessionData: viewModel.myGptSessionData
                )
                
                ChatView(viewModel: chatViewModel) {
                    dismissHostingController()
                }
            }
        }
        .modifier(ColorSchemeModifier(colorScheme: colorScheme))
        .onAppear {
            fetchGptsContent()
        }
        .alert("Error", isPresented: $showAlert) {
            Button("go back", role: .destructive) {
                dismissHostingController()
            }
            Button("Try again", role: .cancel) {
                fetchGptsContent()
            }
        } message: {
            Text(alertMessage)
        }
    }
    
    // MARK: - FUNCTIONS
    
    private func fetchGptsContent() {
        Task {
            do {
                isLoading = true
                try await viewModel.getMyGptsContent()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                    self.colorScheme = AppColorScheme(rawValue: viewModel.myGptSessionData?.data?.first?.uiPreferences?.modeTheme ?? 1)!
                    isLoading = false
                    navigateToChatView = true // Trigger navigation
                    HapticFeedbackManager.shared.triggerNotification(type: .success)
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
    
    private func retryAction() {
        fetchGptsContent() // Retry the API call
    }
    
    private func closeAction() {
        dismissHostingController() // Dismiss the view
    }
    
    func didWidgetTapped(withData: ChatBotWidget?) {
        guard let withData else { return }
        print("StoreId: \(withData.storeId ?? "")")
    }
    
    func dismissHostingController() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = windowScene.windows.first?.rootViewController else {
            return
        }
        rootViewController.dismiss(animated: true, completion: nil)
    }
}


extension LaunchView: ChatBotDelegate {
    
    public func navigateFromBot(withData: ChatBotWidget?, dismissOnSuccess: @escaping (Bool)->()) {
        viewModel.delegate.navigateFromBot(withData: withData, dismissOnSuccess: dismissOnSuccess)
    }
    
}

struct CustomRoundedButton: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void
    private let buttonHeight: CGFloat = 40
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                Text(title)
            }
            .padding()
            .frame(height: buttonHeight)
            .frame(maxWidth: .infinity)
            .overlay(
                RoundedRectangle(cornerRadius: buttonHeight / 2)
                    .stroke(color, lineWidth: 1)
            )
            .foregroundColor(color)
        }
        .buttonStyle(AnimatedButtonStyle())
    }
}

