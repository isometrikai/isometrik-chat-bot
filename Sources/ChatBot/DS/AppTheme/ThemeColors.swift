import UIKit
import SwiftUI

public protocol ThemeColorsProtocol {
    
    var primaryBackgroundColor: Color { get }
    var secondaryBackgroundColor: Color { get }
    
    var primaryColor: Color { get }
    var secondaryColor: Color { get }
    
    var primaryBackgroundColorDarkMode: Color { get }
    var secondaryBackgroundColorDarkMode: Color { get }
    
    var primaryColorDarkMode: Color { get }
    var secondaryColorDarkMode: Color { get }
    
}

public class ThemeColors: ThemeColorsProtocol {
    
    public var primaryBackgroundColor: Color
    public var secondaryBackgroundColor: Color
    
    public var primaryColor: Color
    public var secondaryColor: Color
    
    public var primaryBackgroundColorDarkMode: Color
    public var secondaryBackgroundColorDarkMode: Color
    
    public var primaryColorDarkMode: Color
    public var secondaryColorDarkMode: Color
    
    public init(
        primaryBackgroundColor: UIColor = .white,
        secondaryBackgroundColor: UIColor = UIColor(hex: "#F2F2F7"),
        primaryColor: UIColor = .black,
        secondaryColor: UIColor = .white,
        
        primaryBackgroundColorDarkMode: UIColor = UIColor(hex: "#1B1B1B"),
        secondaryBackgroundColorDarkMode: UIColor = UIColor(hex: "#2B2B2D"),
        primaryColorDarkMode: UIColor = .white,
        secondaryColorDarkMode: UIColor = .black
    ) {
        self.primaryBackgroundColor = primaryBackgroundColor.toSwiftUIColor()
        self.secondaryBackgroundColor = secondaryBackgroundColor.toSwiftUIColor()
        
        self.primaryColor = primaryColor.toSwiftUIColor()
        self.secondaryColor = secondaryColor.toSwiftUIColor()
        
        self.primaryBackgroundColorDarkMode = primaryBackgroundColorDarkMode.toSwiftUIColor()
        self.secondaryBackgroundColorDarkMode = secondaryBackgroundColorDarkMode.toSwiftUIColor()
        
        self.primaryColorDarkMode = primaryColorDarkMode.toSwiftUIColor()
        self.secondaryColorDarkMode = secondaryColorDarkMode.toSwiftUIColor()
    }
    
    // Methods to get the appropriate color based on the color scheme
    public func primaryBackgroundColor(for colorScheme: AppColorScheme) -> Color {
        colorScheme == .dark ? primaryBackgroundColorDarkMode : primaryBackgroundColor
    }
    
    public func secondaryBackgroundColor(for colorScheme: AppColorScheme) -> Color {
        colorScheme == .dark ? secondaryBackgroundColorDarkMode : secondaryBackgroundColor
    }
    
    public func primaryColor(for colorScheme: AppColorScheme) -> Color {
        colorScheme == .dark ? primaryColorDarkMode : primaryColor
    }
    
    public func secondaryColor(for colorScheme: AppColorScheme) -> Color {
        colorScheme == .dark ? secondaryColorDarkMode : secondaryColor
    }
}
