//
//  AnimatedButtonStyle.swift
//  ChatBot
//
//  Created by Appscrip 3Embed on 24/08/24.
//

import SwiftUI

struct AnimatedButtonStyle: ButtonStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.5, blendDuration: 0.5), value: configuration.isPressed)
    }
    
}
