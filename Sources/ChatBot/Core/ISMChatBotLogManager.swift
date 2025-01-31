import Foundation
import os.log

public struct LogTrackingData {
    let eventName: String
    let eventParameters: [String: String]
    let status: Int
}

final public class ISMChatBotLogManager {
    public static let shared = ISMChatBotLogManager()

    private let subsystem: String
    private let generalCategory = "General"
    private let networkCategory = "Network"
    
    // Closure to handle log forwarding to the app
    public var forwardLogs: ((LogTrackingData) -> Void)?

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
    
    func logSuccessEvents(request: URLRequest, status: Int) {
        
        let endpoint = request.url?.path ?? "no_endpoint"
        let eventName = "success_\(endpoint)"
        
        let token = request.allHTTPHeaderFields?["Authorization"] ?? "no_auth_token"
        let httpMethod = request.httpMethod ?? "no_method"
        
        let param: [String: String] = [
            "token": "\(token)",
            "httpMethod": "\(httpMethod)",
        ]
        
        forwardLogs?(LogTrackingData(eventName: eventName, eventParameters: param, status: status))
    }
    
    func logFailureEvents(request: URLRequest, status: Int, data: Data) {
        
        let endpoint = request.url?.path ?? "no_endpoint"
        let eventName = "failure_\(endpoint)"
        
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
        
        let param: [String: String] = [
            "token": "\(token)",
            "httpMethod": "\(httpMethod)",
            "error": "\(errorMsg)"
        ]
        
        
        forwardLogs?(LogTrackingData(eventName: eventName, eventParameters: param, status: status))
    }
    
}
