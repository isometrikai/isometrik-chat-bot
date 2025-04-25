//
//  ChatNetworkService.swift
//  ChatBot
//
//  Created by Appscrip 3Embed on 23/08/24.
//

import Foundation

public protocol ChatAPIService {
    func gptClientMsg(requestParameter: GPTClientRequestParameters) async throws -> GptClientResponseModel
    func myGpts(queryParameter: MyGptsQueryParameter) async throws -> MyGptsResponseModel
}

public struct ChatNetworkService: ChatAPIService {
    
    public let networkClient: NetworkManagable
    
    public init(networkClient: NetworkManagable = NetworkManager()) {
        self.networkClient = networkClient
    }
    
    public func gptClientMsg(requestParameter: GPTClientRequestParameters) async throws -> GptClientResponseModel {
        let apiModel = APIRequestModel(api: ChatAPI.AgentChat, body: requestParameter)
        return try await networkClient.getDecodedData(apiModel: apiModel)
    }
    
    public func myGpts(queryParameter: MyGptsQueryParameter) async throws -> MyGptsResponseModel {
        let apiModel = APIRequestModel(api: ChatAPI.MyGPTs, queryParameters: queryParameter)
        return try await networkClient.getDecodedData(apiModel: apiModel)
    }
    
}
