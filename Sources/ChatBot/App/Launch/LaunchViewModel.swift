//
//  HomeViewModel.swift
//  ChatBot
//
//  Created by Appscrip 3Embed on 24/08/24.
//

import Foundation

public class LaunchViewModel: ObservableObject {
    
    // MARK: - PROPERTIES
    
    @Published var appConfigurations: AppConfigurationManager
    @Published var myGptSessionData: MyGptsResponseModel?
    
    private let apiService: ChatAPIService = ChatNetworkService()
    private let networkMiddleware: NetworkMiddleware
    
    // MARK: - INITIALIZER
    
    public init(appConfigurations: AppConfigurationManager){
        self.appConfigurations = appConfigurations
        self.networkMiddleware = NetworkMiddleware(appConfig: appConfigurations)
    }
    
    // MARK: - METHODS
    
    func getMyGptsContent() async throws {
        Task {
            do {
                let parameters = MyGptsQueryParameter(
                    id: "188"
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
