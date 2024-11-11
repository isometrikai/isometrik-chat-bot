//
//  UserDefaultsManager.swift
//  ChatBot
//
//  Created by Appscrip 3Embed on 24/08/24.
//

import Foundation

public enum ISMChatBotUserDefaultKey: String {
    case accessToken = "access_token"
    case userInteractedWithChatBot = "user_interacted_with_chatbot"
}

public struct ISMChatBotUserDefaultsManager {
    
    private static let userDefaults = UserDefaults.standard
    
    public static func setValue(_ value: Any?, forKey key: String) {
        userDefaults.set(value, forKey: key)
        userDefaults.synchronize()
    }
    
    public static func getValue(forKey key: String) -> Any? {
        return userDefaults.value(forKey: key)
    }
    
    public static func removeValue(forKey key: String) {
        userDefaults.removeObject(forKey: key)
        userDefaults.synchronize()
    }
    
    public static func resetAllDefaults() {
        guard let appDomain = Bundle.main.bundleIdentifier else { return }
        userDefaults.removePersistentDomain(forName: appDomain)
        userDefaults.synchronize()
    }
}
