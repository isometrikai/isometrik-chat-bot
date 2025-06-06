//
//  ChatRequestModel.swift
//  ChatBot
//
//  Created by Appscrip 3Embed on 23/08/24.
//

import Foundation

public struct GPTClientRequestParameters: Codable {
    
    public let message: String
    public let sessionId: String
    public let longitude: String
    public let latitude: String
    public let isLoggedIn: Bool
    public let fingerPrintId: String
    public let agentId: String
    
    enum CodingKeys: String, CodingKey {
        case message
        case sessionId = "session_id"
        case longitude
        case latitude
        case isLoggedIn
        case fingerPrintId = "finger_print_id"
        case agentId = "agent_id"
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.message, forKey: .message)
        try container.encode(self.sessionId, forKey: .sessionId)
        try container.encode(self.longitude, forKey: .longitude)
        try container.encode(self.latitude, forKey: .latitude)
        try container.encode(self.isLoggedIn, forKey: .isLoggedIn)
        try container.encode(self.fingerPrintId, forKey: .fingerPrintId)
        try container.encode(self.agentId, forKey: .agentId)
    }
    
}


public struct MyGptsQueryParameter: Encodable {
    public let id: String
}
