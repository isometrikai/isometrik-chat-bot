//
//  ImageLoader.swift
//  ChatBot
//
//  Created by Appscrip 3Embed on 23/08/24.
//

import SwiftUI
import SDWebImage

class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    @Published var isLoading: Bool = false
    
    func loadImage(from url: URL?) {
        guard let url = url else { return }
        
        isLoading = true
        
        SDWebImageManager.shared.loadImage(
            with: url,
            options: .highPriority,
            progress: nil
        ) { [weak self] (image, data, error, cacheType, finished, url) in
            guard let self = self else { return }
            self.isLoading = false
            
            if let error = error {
                print("Failed to load image: \(error)")
                return
            }
            
            self.image = image
        }
    }
}

struct URLImageView: View {
    @ObservedObject var loader: ImageLoader
    
    let placeholder: Image
    
    init(url: URL?, placeholder: Image = Image(systemName: "demo_dish1")) {
        loader = ImageLoader()
        self.placeholder = placeholder
        loader.loadImage(from: url)
    }
    
    var body: some View {
        if loader.isLoading {
            ProgressView()
        } else if let image = loader.image {
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
        } else {
            placeholder
                .resizable()
                .scaledToFit()
        }
    }
}


