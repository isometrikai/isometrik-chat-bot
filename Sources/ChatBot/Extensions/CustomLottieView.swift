//
//  CustomLottieView.swift
//  ChatBot
//
//  Created by Appscrip 3Embed on 25/08/24.
//

import SwiftUI
import Lottie

struct LottieView: UIViewRepresentable {
    
    private var filename: String?
    private var filePath: String?
    var loopMode: LottieLoopMode = .loop
    
    init(filename: String) {
        self.filename = filename
    }
    
    init(filePath: String) {
        self.filePath = filePath
    }
    
    private let animationView = LottieAnimationView() // Avoid making it optional
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        
        // Load the animation from either filename or file path
        if let filename = filename {
            animationView.animation = LottieAnimation.named(filename)
        } else if let filePath = filePath {
            animationView.animation = LottieAnimation.filepath(filePath)
        } else {
            // If neither filename nor filePath are provided, return an empty view
            return view
        }
        
        // Set content mode and loop mode
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = loopMode
        animationView.play()
        
        // Add the animation view to the parent view
        view.addSubview(animationView)
        
        // Set constraints for the animation view
        animationView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor),
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
        
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        // Update the view if needed
    }
}
