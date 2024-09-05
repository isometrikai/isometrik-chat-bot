//
//  HomeViewModel.swift
//  ChatBot
//
//  Created by Appscrip 3Embed on 24/08/24.
//

import Foundation

public class LaunchViewModel: ObservableObject {
    
    // MARK: - PROPERTIES
    
    public var delegate: ChatBotDelegate
    
    @Published var appConfigurations: AppConfigurationManager
    @Published var myGptSessionData: MyGptsResponseModel?
    
    private let apiService: ChatAPIService = ChatNetworkService()
    private let networkMiddleware: NetworkMiddleware
    
    // MARK: - INITIALIZER
    
    public init(appConfigurations: AppConfigurationManager, delegate: ChatBotDelegate){
        self.appConfigurations = appConfigurations
        self.networkMiddleware = NetworkMiddleware(appConfig: appConfigurations)
        self.delegate = delegate
    }
    
    // MARK: - METHODS
    
    func getMyGptsContent() async throws {
        Task {
            do {
                let parameters = MyGptsQueryParameter(
                    id: appConfigurations.chatBotId
                )
                
                let data = try await networkMiddleware.performRequest {
                    return try await self.apiService.myGpts(queryParameter: parameters)
                }
                
                DispatchQueue.main.async {
                    self.myGptSessionData = data
                }
            }
        }
    }
    
}
