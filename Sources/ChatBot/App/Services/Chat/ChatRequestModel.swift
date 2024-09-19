//
//  ChatRequestModel.swift
//  ChatBot
//
//  Created by Appscrip 3Embed on 23/08/24.
//

import Foundation

public struct GPTClientRequestParameters: Encodable {
    
    public let chatBotId: Int
    public let message: String
    public let sessionId: String
    public let storeCategoryId: String
    public let userId: String
    public let location: String
    public let longitude: Float
    public let latitude: Float
    
    enum CodingKeys: String, CodingKey {
        case chatBotId = "chat_bot_id"
        case message
        case sessionId
        case storeCategoryId
        case userId
        case location
        case longitude
        case latitude
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.chatBotId, forKey: .chatBotId)
        try container.encode(self.message, forKey: .message)
        try container.encode(self.sessionId, forKey: .sessionId)
        try container.encode(self.storeCategoryId, forKey: .storeCategoryId)
        try container.encode(self.userId, forKey: .userId)
        try container.encode(self.location, forKey: .location)
        try container.encode(self.longitude, forKey: .longitude)
        try container.encode(self.latitude, forKey: .latitude)
    }
    
}


public struct MyGptsQueryParameter: Encodable {
    public let id: String
}
