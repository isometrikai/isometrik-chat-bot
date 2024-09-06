//
//  LoaderView.swift
//  ChatBot
//
//  Created by Appscrip 3Embed on 28/08/24.
//

import SwiftUI

struct LoaderView: View {
    
    // MARK: - PROPERTIES
    
    @State private var currentTaglineIndex = 0
    @State private var animateText = false
    let tagLines = [
        "Building your personalized chat experience...",
        "Loading your smart conversation space...",
        "Tailoring your chat journey just for you...",
        "Configuring the chat that gets you...",
        "Preparing your next-level conversation..."
    ]
    
    // MARK: - BODY
    
    var body: some View {
        VStack(spacing: 20) {
            ProgressView()

            Text(tagLines[currentTaglineIndex])
                .font(.headline)
                .opacity(animateText ? 1 : 0)
                .animation(.easeInOut(duration: 0.3), value: animateText)
                .onAppear {
                    startTaglineRotation()
                }
        }
    }
    
    // MARK: - FUNCTIONS
    
    func startTaglineRotation() {
        Timer.scheduledTimer(withTimeInterval: 1.5, repeats: true) { timer in
            withAnimation {
                animateText = false
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                currentTaglineIndex = (currentTaglineIndex + 1) % tagLines.count
                withAnimation {
                    animateText = true
                }
            }
        }
    }
    
}

#Preview {
    LoaderView()
}
