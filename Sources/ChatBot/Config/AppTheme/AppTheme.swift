
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
    
    public init(
        images: ThemeImages = ThemeImages(),
        jsonFiles: ThemeJsonFiles = ThemeJsonFiles()
    ) {
        self.images = images
        self.jsonFiles = jsonFiles
    }
}
