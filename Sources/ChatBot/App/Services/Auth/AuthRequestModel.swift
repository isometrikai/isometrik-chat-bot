//
//  AuthRequestModel.swift
//  ChatBot
//
//  Created by Appscrip 3Embed on 24/08/24.
//

import Foundation

struct AccessTokenRequestParameters: Encodable {
    
    let appSecret: String
    let licensekey: String
    let fingerprintId: String
    let createIsometrikUser = true
    
    enum CodingKeys: CodingKey {
        case appSecret
        case licensekey
        case fingerprintId
        case createIsometrikUser
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.appSecret, forKey: .appSecret)
        try container.encode(self.licensekey, forKey: .licensekey)
        try container.encode(self.fingerprintId, forKey: .fingerprintId)
        try container.encode(self.createIsometrikUser, forKey: .createIsometrikUser)
    }
    
}
