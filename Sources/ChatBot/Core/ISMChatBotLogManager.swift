import Foundation
import os.log

public enum ISMChatBotLogType {
    case success
    case failure
}

public struct ISMChatBotLogTrackingData {
    public let eventName: String
    public var eventParameters: [String: String] // `mutable` as we can add more parametes externaly
    public let status: Int
    public let logType: ISMChatBotLogType
}

final public class ISMChatBotLogManager {
    public static let shared = ISMChatBotLogManager()

    private let subsystem: String
    private let generalCategory = "General"
    private let networkCategory = "Network"
    
    // Closure to handle log forwarding to the app
    public var forwardedLogs: ((ISMChatBotLogTrackingData) -> Void)?

    private init() {
        self.subsystem = "com.isometrik.chatbot"
    }

    private func logger(for category: String) -> OSLog {
        return OSLog(subsystem: subsystem, category: category)
    }

    private func formattedMessage(_ message: String, type: OSLogType, file: String, line: Int) -> String {
        let prefix = ISMChatBotLogManager.prefixes[type.rawValue] ?? ""
        let fileName = (file as NSString).lastPathComponent
        return "\(prefix) [\(type.description)] [\(fileName):\(line)] > \(message)"
    }

    public func logGeneral(_ message: String, type: OSLogType = .default, file: String = #file, line: Int = #line) {
        os_log("%{public}@", log: logger(for: generalCategory), type: type, formattedMessage(message, type: type, file: file, line: line))
    }

    public func logNetwork(_ message: String, type: OSLogType = .default, file: String = #file, line: Int = #line) {
        os_log("%{public}@", log: logger(for: networkCategory), type: type, formattedMessage(message, type: type, file: file, line: line))
    }
    
    public func logCustom(category: String, message: String, type: OSLogType = .default, file: String = #file, line: Int = #line) {
        os_log("%{public}@", log: logger(for: category), type: type, formattedMessage(message, type: type, file: file, line: line))
    }

    // Define the prefixes for each log type
    private static let prefixes: [UInt8: String] = [
        OSLogType.info.rawValue: "ℹ️",
        OSLogType.debug.rawValue: "🛠",
        OSLogType.error.rawValue: "🚨",
        OSLogType.fault.rawValue: "💥",
        OSLogType.default.rawValue: ""
    ]
}

private extension OSLogType {
    var description: String {
        switch self {
        case .info:
            return "INFO"
        case .debug:
            return "DEBUG"
        case .error:
            return "ERROR"
        case .fault:
            return "FAULT"
        default:
            return "DEFAULT"
        }
    }
}

extension ISMChatBotLogManager {
    
    func logSuccessEvents(request: URLRequest, status: Int, responseData: Data) {
        
        let endpoint = request.url?.path ?? "no_endpoint"
        let cleanedEndpoint = endpoint.replacingOccurrences(of: "/", with: "_")
        let eventName = "ismchatbot_success\(cleanedEndpoint)"
        
        let token = request.allHTTPHeaderFields?["Authorization"] ?? "no_auth_token"
        let httpMethod = request.httpMethod ?? "no_method"
        
        // Extract last 8 characters of token
        let tokenLast8 = token.suffix(8)
        
        var param: [String: String] = [
            "token": "..\(tokenLast8)",
            "httpMethod": "\(httpMethod)",
        ]
        
        // parse the body data for logs
        let messageSent: String?
        let location: String?
        
        if let bodyData = request.httpBody {
            let decoder = JSONDecoder()
            if let json = try? decoder.decode(GPTClientRequestParameters.self, from: bodyData) {
                param["messageToBot"] = "\(json.message)"
            }
        }
        
        // parse the response data for logs
        let decoder = JSONDecoder()
        if let json = try? decoder.decode(GptClientResponseModel.self, from: responseData) {
            if let text = json.text {
                param["chatBotResponse"] = "\(text)"
            }
        }
        
        forwardedLogs?(ISMChatBotLogTrackingData(eventName: eventName, eventParameters: param, status: status, logType: .success))
    }
    
    func logFailureEvents(request: URLRequest, status: Int, data: Data) {
        
        let endpoint = request.url?.path ?? "no_endpoint"
        let cleanedEndpoint = endpoint.replacingOccurrences(of: "/", with: "_")
        let eventName = "ismchatbot_failure\(cleanedEndpoint)"
        
        let token = request.allHTTPHeaderFields?["Authorization"] ?? "no_auth_token"
        let httpMethod = request.httpMethod ?? "no_method"
        
        // parse the data for error message
        let errorMsg: String
        if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
           let message = json["message"] as? String {
            errorMsg = message
        } else {
            errorMsg = "Unknown error"
        }
        
        // Extract last 8 characters of token
        let tokenLast8 = token.suffix(8)
        
        let param: [String: String] = [
            "token": "..\(tokenLast8)",
            "httpMethod": "\(httpMethod)",
            "error": "\(errorMsg)"
        ]
        
        forwardedLogs?(ISMChatBotLogTrackingData(eventName: eventName, eventParameters: param, status: status, logType: .failure))
    }
    
}
