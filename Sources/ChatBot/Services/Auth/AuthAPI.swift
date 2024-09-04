//
//  AuthAPI.swift
//  ChatBot
//
//  Created by Appscrip 3Embed on 24/08/24.
//

import Foundation

enum AuthAPI {
    case getAccessToken
}

extension AuthAPI: APIProtocol {
    
    func httpMthodType() -> HTTPMethodType {
        switch self {
        case .getAccessToken: return .post
        }
    }
    
    func apiEndPath() -> String {
        var path = "/v2"
        
        switch self {
        case .getAccessToken:
            path += "/guestAuth"
        }
        
        return path
    }
    
    func apiBasePath() -> String {
        return "https://service-apis.isometrik.io"
    }
    
    func additionalHeader() -> [String : String] {
        return [:]
    }
    
    var timeout: Double {
        30
    }
    
    
}

