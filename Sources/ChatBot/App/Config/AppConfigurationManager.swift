//
//  AppConfigurationManager.swift
//  ChatBot
//
//  Created by Appscrip 3Embed on 23/08/24.
//

import Foundation

public class AppConfigurationManager {
    
    public let chatBotId: String
    public let appTheme: AppTheme
    public let appSecret: String
    public let licenseKey: String
    public let userId: String
    public let storeCategoryId: String
    
    public init(
        chatBotId: String,
        userId: String,
        appSecret: String,
        licenseKey: String,
        storeCategoryId: String,
        appTheme: AppTheme = AppTheme()
    ) {
        self.chatBotId = chatBotId
        self.appTheme = appTheme
        self.appSecret = appSecret
        self.licenseKey = licenseKey
        self.userId = userId
        self.storeCategoryId = storeCategoryId
    }
    
}
