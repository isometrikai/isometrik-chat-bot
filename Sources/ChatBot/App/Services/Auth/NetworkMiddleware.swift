//
//  NetworkMiddleware.swift
//  ChatBot
//
//  Created by Appscrip 3Embed on 24/08/24.
//

// Copyright © SnapNews. All rights reserved.

import Foundation
import UIKit

final class NetworkMiddleware {
    
    var apiService: AuthAPIService
    var appConfig: AppConfigurationManager
    
    init(
        apiService: AuthAPIService = AuthNetworkService(),
        appConfig: AppConfigurationManager
    ) {
        self.apiService = apiService
        self.appConfig = appConfig
    }
    
    public func handleNetworkingErrors(_ error: NetworkError) async -> Bool {
        switch error {
        case .decodingError(let decodingError):
            logError("Decoding error: \(decodingError.localizedDescription)")
            return false
            
        case .incorrectURL, .unknown, .noResponse, .timeout:
            logError(error.localizedDescription)
            return false
            
        case .unauthorized:
            return await handleUnauthorizedError()
        }
    }
    
    private func logError(_ message: String) {
        LogManager.shared.logNetwork(message, type: .error)
    }
    
    private func handleUnauthorizedError() async -> Bool {
        do {
            
            // decode userid if it's base64 encoded
            let decodedUserId = decodeBase64(base64String: appConfig.userId) ?? "unknownUserId"
            
            let bodyParameter = AccessTokenRequestParameters(
                appSecret: appConfig.appSecret,
                licensekey: appConfig.licenseKey,
                fingerprintId: decodedUserId
            )
            let data = try await apiService.getAccessToken(requestParameter: bodyParameter)
            
            guard let accessTokenData = data.data, let accessToken = accessTokenData.accessToken  else {
                logError("Failed to get access token!")
                return false
            }
            
            ISMChatBotUserDefaultsManager.setValue(accessToken, forKey: ISMChatBotUserDefaultKey.accessToken.rawValue)
            
            return true
            
        } catch {
            logError("You've been logged out!")
            return false
        }
    }
    
    public func performRequest<T>(request: @escaping () async throws -> T) async throws -> T {
        do {
            return try await request()
        } catch let error as NetworkError {
            if case .unauthorized = error, await handleUnauthorizedError() {
                return try await request()
            }
            throw error
        }
    }
    
    // Helper function to decode Base64 string
    private func decodeBase64(base64String: String) -> String? {
        guard let data = Data(base64Encoded: base64String) else {
            logError("Failed to decode Base64 string.")
            return nil
        }
        return String(data: data, encoding: .utf8)
    }
    
}

