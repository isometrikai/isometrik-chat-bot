// Copyright © SnapNews. All rights reserved.

import Foundation

enum JSONResponseDecoder {
    static func decode<T: Decodable>(_ responseData: Data) async throws -> T {
        do {
            let model = try JSONDecoder().decode(T.self, from: responseData)
            return model
        } catch let DecodingError.dataCorrupted(context) {
            print("Data corrupted: ", context)
            throw DecodingError.dataCorrupted(context)
        } catch let DecodingError.keyNotFound(key, context) {
            print("Key '\(key)' not found: ", context.debugDescription, "\n codingPath:", context.codingPath)
            throw DecodingError.keyNotFound(key, context)
        } catch let DecodingError.valueNotFound(value, context) {
            print("Value '\(value)' not found: ", context.debugDescription, "\n codingPath:", context.codingPath)
            throw DecodingError.valueNotFound(value, context)
        } catch let DecodingError.typeMismatch(type, context) {
            print("Type '\(type)' mismatch: ", context.debugDescription, "\n codingPath:", context.codingPath)
            throw DecodingError.typeMismatch(type, context)
        } catch {
            print("error: ", error.localizedDescription)
            throw error
        }
    }
}

