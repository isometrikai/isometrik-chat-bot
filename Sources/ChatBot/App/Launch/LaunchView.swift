//
//  LaunchView.swift
//  ChatBot
//
//  Created by Appscrip 3Embed on 23/08/24.
//

import SwiftUI

public struct LaunchView: View {
    
    // MARK: - PROPERTIES
    
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
            ZStack(alignment: .bottomTrailing){
                VStack {
                    if isLoading {
                        LoaderView()
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
            .background(Color.white)
            .navigationBarHidden(true)
            .onAppear {
                scaleEffect = true
            }
            .navigationDestination(isPresented: $navigateToChatView) {
                ChatView(viewModel: ChatViewModel(apiService: ChatNetworkService(), appConfig: viewModel.appConfigurations, delegate: self, myGptSessionData: viewModel.myGptSessionData))
            }
        }
        .onAppear {
            Task {
                do {
                    isLoading = true
                    try await viewModel.getMyGptsContent()
                    try await Task.sleep(nanoseconds: 4_000_000_000) // 4 second delay intentionally added
                    isLoading = false
                    navigateToChatView = true // Trigger navigation
                } catch {
                    // Handle the error here
                    isLoading = false
                    alertMessage = "Failed to get content: \(error.localizedDescription)"
                    showAlert = true
                }
            }
        }
        .alert("Error", isPresented: $showAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(alertMessage)
        }
    }
    
    func didWidgetTapped(withData: ChatBotWidget?) {
        guard let withData else { return }
        print("StoreId: \(withData.storeId ?? "")")
    }
}


extension LaunchView: ChatBotDelegate {
    
    public func navigateFromBot(withData: ChatBotWidget?, forType: WidgetType?) {
        viewModel.delegate.navigateFromBot(withData: withData, forType: forType)
    }
    
}
