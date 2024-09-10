import Foundation
import UIKit

public final class PopupManager: PopupPresentable {
    
    public static let shared = PopupManager()
    
    private init() {}
    
    public func showPopup(title: String, message: String, animationType: PopupAnimationType = .scale, actions: [PopupAction]) {
        
        guard let topViewController = UIApplication.shared.topMostViewController() else {
            return
        }
        
        let coverView = UIView(frame: topViewController.view.bounds)
        coverView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        
        let popupView = CustomPopupView(title: title, message: message, animationType: animationType)
        popupView.actions = actions
        popupView.translatesAutoresizingMaskIntoConstraints = false
        
        popupView.present(on: topViewController.view, coverView: coverView)
        
    }
    
}

private extension UIApplication {
    func topMostViewController() -> UIViewController? {
        guard let window = windows.filter({ $0.isKeyWindow }).first else {
            return nil
        }
        var topController: UIViewController? = window.rootViewController
        while let presentedViewController = topController?.presentedViewController {
            topController = presentedViewController
        }
        return topController
    }
}
