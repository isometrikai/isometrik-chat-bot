import Foundation

public struct ThemeJsonFiles {
    
    private static func loadJSONFileSafely(with fileName: String) -> String {
    
        if let path = Bundle.chatBotBundle.path(forResource: fileName, ofType: "json") {
            return path
        } else {
            print(
                """
                \(fileName) path has failed to load from the bundle please make sure it's included in your resources folder.
                """
            )
            return ""
        }
    }
        
    public var botResponseLoaderBlack : String = loadJSONFileSafely(with: "bubble-wave-black")
    public var botResponseLoaderWhite : String = loadJSONFileSafely(with: "bubble-wave-white")
    
    public init(){}
    
}
