
import SwiftUI

public struct CustomColorScheme: EnvironmentKey {
    public static let defaultValue: AppColorScheme = .light // Provide a default theme
}

extension EnvironmentValues {
    var customScheme: AppColorScheme {
        get { self[CustomColorScheme.self] }
        set { self[CustomColorScheme.self] = newValue }
    }
}

public enum AppColorScheme: Int {
    case light = 1
    case dark
}

public struct ColorSchemeModifier: ViewModifier {
    let colorScheme: AppColorScheme
    
    public func body(content: Content) -> some View {
        content.environment(\.customScheme, colorScheme)
    }
}


