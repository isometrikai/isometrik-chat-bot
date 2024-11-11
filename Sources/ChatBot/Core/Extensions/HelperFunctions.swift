//
//  File.swift
//  ChatBot
//
//  Created by Appscrip 3Embed on 11/11/24.
//

import SwiftUI

public func dismissHostingController(animated: Bool = true, completion: (()->Void)? = nil) {
    guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
          let rootViewController = windowScene.windows.first?.rootViewController else {
        return
    }
    rootViewController.dismiss(animated: animated, completion: completion)
}
