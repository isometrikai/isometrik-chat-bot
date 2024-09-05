
import Foundation
import SwiftUI

public class AppTheme {
    public var theme: Theme
    public init(theme: Theme = Theme()) {
        self.theme = theme
    }
}

public class Theme {
    public var images : ThemeImages
    public var jsonFiles: ThemeJsonFiles
    public var colors: ThemeColors
    
    public init(
        images: ThemeImages = ThemeImages(),
        jsonFiles: ThemeJsonFiles = ThemeJsonFiles(),
        colors: ThemeColors = ThemeColors()
    ) {
        self.images = images
        self.jsonFiles = jsonFiles
        self.colors = colors
    }
}
