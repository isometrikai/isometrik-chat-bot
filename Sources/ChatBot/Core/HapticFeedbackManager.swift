import SwiftUI
import UIKit

public class HapticFeedbackManager {
    
    public static let shared = HapticFeedbackManager()
    
    private let lightFeedback = UIImpactFeedbackGenerator(style: .light)
    private let mediumFeedback = UIImpactFeedbackGenerator(style: .medium)
    private let heavyFeedback = UIImpactFeedbackGenerator(style: .heavy)
    private let softFeedback = UIImpactFeedbackGenerator(style: .soft)
    private let rigidFeedback = UIImpactFeedbackGenerator(style: .rigid)
    private let selectionFeedback = UISelectionFeedbackGenerator()
    private let notificationFeedback = UINotificationFeedbackGenerator()
    
    // Feedback styles
    public func triggerImpact(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let feedbackGenerator = UIImpactFeedbackGenerator(style: style)
        feedbackGenerator.impactOccurred()
    }
    
    // For selection changes
    public func triggerSelection() {
        selectionFeedback.selectionChanged()
    }
    
    // For notifications like success, warning, or error
    public func triggerNotification(type: UINotificationFeedbackGenerator.FeedbackType) {
        notificationFeedback.notificationOccurred(type)
    }
}

