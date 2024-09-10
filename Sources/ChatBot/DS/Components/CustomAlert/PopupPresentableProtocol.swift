// Copyright © SnapNews. All rights reserved.

import Foundation

public enum PopupButtonType {
    case destructive
    case cancel
    case _default
}

public enum PopupAnimationType {
    case slideInBottom
    case scale
}

public protocol PopupPresentable {
    func showPopup(title: String, message: String, animationType: PopupAnimationType, actions: [PopupAction])
}

public struct PopupAction {
    public let title: String
    public let buttonType: PopupButtonType
    public let handler: (() -> Void)?
    
    public init(
        title: String,
        buttonType: PopupButtonType = ._default,
        handler: (() -> Void)?
    ) {
            self.title = title
            self.buttonType = buttonType
            self.handler = handler
    }
}
