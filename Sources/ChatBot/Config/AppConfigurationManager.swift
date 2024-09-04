//
//  AppConfigurationManager.swift
//  ChatBot
//
//  Created by Appscrip 3Embed on 23/08/24.
//

import Foundation

public class AppConfigurationManager {
    
    public let appTheme: AppTheme
    public let appSecret: String
    public let licenseKey: String
    public let fingerprintId: String
    public let userId: String
    public let storeCategoryId: String
    
    public init(
        appTheme: AppTheme = AppTheme(),
        appSecret: String,
        licenseKey: String,
        fingerprintId: String,
        userId: String,
        storeCategoryId: String
    ) {
        self.appTheme = appTheme
        self.appSecret = appSecret
        self.licenseKey = licenseKey
        self.fingerprintId = fingerprintId
        self.userId = userId
        self.storeCategoryId = storeCategoryId
    }
    
}
