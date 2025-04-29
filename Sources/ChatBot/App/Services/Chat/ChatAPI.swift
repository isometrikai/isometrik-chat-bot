//
//  ChatAPI.swift
//  ChatBot
//
//  Created by Appscrip 3Embed on 23/08/24.
//

import Foundation

enum ChatAPI {
    case AgentChat
    case MyGPTs
}

extension ChatAPI: APIProtocol {
    
    func httpMthodType() -> HTTPMethodType {
        switch self {
        case .AgentChat: return .post
        case .MyGPTs: return .get
        }
    }
    
    func apiEndPath() -> String {
        var path = "/v1"
        
        switch self {
        case .AgentChat:
            path += "/eazy/agent-chat"
        case .MyGPTs:
            path += "/guest/mygpts"
        }
        
        return path
    }
    
    func apiBasePath() -> String {
        return "https://service-apis.isometrik.io"
    }
    
    func additionalHeader() -> [String : String] {
        if let accessToken = ISMChatBotUserDefaultsManager.getValue(forKey: ISMChatBotUserDefaultKey.accessToken.rawValue) {
            return [
                "Authorization": "\(accessToken)"
            ]
        }
        return [:]
    }
    
    var timeout: Double {
        30
    }
    
    
}
