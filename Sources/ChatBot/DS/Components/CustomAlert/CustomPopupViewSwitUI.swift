import SwiftUI
import UIKit

// SwiftUI wrapper for PopupManager
struct PopupView: UIViewControllerRepresentable {
    var title: String
    var message: String
    var animationType: PopupAnimationType
    var actions: [PopupAction]

    func makeUIViewController(context: Context) -> UIViewController {
        return UIViewController()
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        DispatchQueue.main.async {
            PopupManager.shared.showPopup(
                title: title,
                message: message,
                animationType: animationType,
                actions: actions
            )
        }
    }
}

