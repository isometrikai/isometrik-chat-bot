//
//  UserDefaultsManager.swift
//  ChatBot
//
//  Created by Appscrip 3Embed on 24/08/24.
//

import Foundation

public enum UserDefaultKey: String {
    case accessToken = "access_token"
}

public struct UserDefaultsManager {
    
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
}
