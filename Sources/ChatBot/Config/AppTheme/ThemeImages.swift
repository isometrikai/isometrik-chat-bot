import SwiftUI

public struct ThemeImages {
    
    private static func loadImageSafely(with imageName: String) -> Image {
        return Image(imageName, bundle: .chatBotBundle)
    }
    
    private static func loadSafely(systemName: String, assetsFallback: String) -> Image {
        if #available(iOS 13.0, *) {
            return Image(systemName: systemName)
        } else {
            return loadImageSafely(with: assetsFallback)
        }
    }
    
    public var appLogo : Image = loadImageSafely(with: "ez_logo")
    public var sendMessage : Image = loadImageSafely(with: "ic_send")
    public var stopResponse : Image = loadImageSafely(with: "ic_stop")
    public var welcomeBot : Image = loadImageSafely(with: "butler")
    public var storeDelivery : Image = loadImageSafely(with: "ic_delivery")
    public var storeDinein : Image = loadImageSafely(with: "ic_dinein")
    public var storePickup : Image = loadImageSafely(with: "ic_pickup")
    
    public init(){}
    
    public init(
        appLogo: Image? = nil,
        sendMessage: Image? = nil,
        stopResponse: Image? = nil,
        welcomeBot: Image? = nil,
        storeDelivery: Image? = nil,
        storeDinein: Image? = nil,
        storePickup: Image? = nil
    ) {
        if let appLogo { self.appLogo = appLogo }
        if let sendMessage { self.sendMessage = sendMessage }
        if let stopResponse { self.stopResponse = stopResponse }
        if let welcomeBot { self.welcomeBot = welcomeBot }
        if let storeDelivery { self.storeDelivery = storeDelivery }
        if let storeDinein { self.storeDinein = storeDinein }
        if let storePickup { self.storePickup = storePickup }
    }
    
}
    
