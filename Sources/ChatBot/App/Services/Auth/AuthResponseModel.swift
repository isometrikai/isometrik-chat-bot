//
//  AuthResponseModel.swift
//  ChatBot
//
//  Created by Appscrip 3Embed on 24/08/24.
//

import Foundation

struct AccessTokenResponseModel: Decodable {
    
    let message: String?
    let data: AccessTokenData?
    
    enum CodingKeys: CodingKey {
        case message
        case data
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.message = try container.decodeIfPresent(String.self, forKey: .message)
        self.data = try container.decodeIfPresent(AccessTokenData.self, forKey: .data)
    }
    
}

struct AccessTokenData: Decodable {
    
    let accessToken: String?
    let accessExpireAt: Int64?
    let refreshToken: String?
    let isometrikToken: String?
    let isometrikUserId: String?
    
    enum CodingKeys: CodingKey {
        case accessToken
        case accessExpireAt
        case refreshToken
        case isometrikToken
        case isometrikUserId
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.accessToken = try container.decodeIfPresent(String.self, forKey: .accessToken)
        self.accessExpireAt = try container.decodeIfPresent(Int64.self, forKey: .accessExpireAt)
        self.refreshToken = try container.decodeIfPresent(String.self, forKey: .refreshToken)
        self.isometrikToken = try container.decodeIfPresent(String.self, forKey: .isometrikToken)
        self.isometrikUserId = try container.decodeIfPresent(String.self, forKey: .isometrikUserId)
    }
    
}
