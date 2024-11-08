//
//  ChatAPI.swift
//  ChatBot
//
//  Created by Appscrip 3Embed on 23/08/24.
//

import Foundation

enum ChatAPI {
    case GPTClientMsg
    case MyGPTs
}

extension ChatAPI: APIProtocol {
    
    func httpMthodType() -> HTTPMethodType {
        switch self {
        case .GPTClientMsg: return .post
        case .MyGPTs: return .get
        }
    }
    
    func apiEndPath() -> String {
        var path = "/v1"
        
        switch self {
        case .GPTClientMsg:
            path += "/gptClientMsg"
        case .MyGPTs:
            path += "/guest/mygpts"
        }
        
        return path
    }
    
    func apiBasePath() -> String {
        return "https://service-apis.isometrik.io"
    }
    
    func additionalHeader() -> [String : String] {
        if let accessToken = UserDefaultsManager.getValue(forKey: UserDefaultKey.accessToken.rawValue) {
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
