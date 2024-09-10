//
//  AuthNetworkService.swift
//  ChatBot
//
//  Created by Appscrip 3Embed on 24/08/24.
//

import Foundation

protocol AuthAPIService {
    func getAccessToken(requestParameter: AccessTokenRequestParameters) async throws -> AccessTokenResponseModel
}

struct AuthNetworkService: AuthAPIService {
    
    let networkClient: NetworkManagable
    
    init(networkClient: NetworkManagable = NetworkManager()) {
        self.networkClient = networkClient
    }
    
    func getAccessToken(requestParameter: AccessTokenRequestParameters) async throws -> AccessTokenResponseModel {
        let apiModel = APIRequestModel(api: AuthAPI.getAccessToken, body: requestParameter)
        return try await networkClient.getDecodedData(apiModel: apiModel)
    }
    
}
