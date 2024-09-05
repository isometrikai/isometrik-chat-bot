//
//  Colors+Extension.swift
//  ChatBot
//
//  Created by Appscrip 3Embed on 23/08/24.
//

import SwiftUI
import UIKit

extension Color {
    public init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

extension UIColor {
    
    // Initialize UIColor with hex
    public convenience init(hex: String) {
        let hex = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        let scanner = Scanner(string: hex)
        if hex.hasPrefix("#") {
            scanner.scanLocation = 1
        }
        
        var color: UInt64 = 0
        scanner.scanHexInt64(&color)
        
        let red = CGFloat((color >> 16) & 0xFF) / 255.0
        let green = CGFloat((color >> 8) & 0xFF) / 255.0
        let blue = CGFloat(color & 0xFF) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
    
    // Convert UIColor to Color
    func toSwiftUIColor() -> Color {
        return Color(self)
    }
}


public func textColorStyle(forHex hex: String) -> String {
    let color = Color(hex: hex)
    let components = UIColor(color).cgColor.components!
    
    let red = components[0] * 0.299
    let green = components[1] * 0.587
    let blue = components[2] * 0.114
    
    let luminance = red + green + blue
    
    return luminance > 0.5 ? "dark" : "light"
}

