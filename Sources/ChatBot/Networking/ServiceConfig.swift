// Copyright © SnapNews. All rights reserved.

import Foundation

/// HTTPMethodTypes
public enum HTTPMethodType: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

/// Protocol to which every API should confirm to.
public protocol APIProtocol {
    func httpMthodType() -> HTTPMethodType
    func apiEndPath() -> String
    func apiBasePath() -> String
    func additionalHeader() -> [String: String]
    var timeout: Double { get }
}

/// Request Model type that the APIRequestModel confirms to.
public protocol APIModelType {
    var api: APIProtocol { get }
    var parameters: [String: Any]? { get }
    var queryParameters: [String: String]? { get }
}

/// Request Model that holds every api calls parameters, headers and other api details.
public struct APIRequestModel: APIModelType {
    public let api: APIProtocol
    public let parameters: [String: Any]?
    public let queryParameters: [String: String]?

    public init(api: APIProtocol, body: Encodable? = nil, queryParameters: Encodable? = nil) {
        self.api = api
        self.parameters = body?.dictionary
        self.queryParameters = queryParameters?.parameterdictionary
    }
}

/// Responsible for generating common headers for requests.
struct ServiceConfig {
    /// Generates common headers specific to APIs. Can also accept additional headers if demanded by specific APIs.
    ///
    /// - Returns: A configured header JSON dictionary which includes both common and additional params.
    func generateHeader() -> [String: String] {
        var headerDict = [String: String]()
        headerDict["Content-Type"] = "application/json"
        return headerDict
    }
}

extension Encodable {
    var dictionary: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
    
    var parameterdictionary: [String: String]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: String] }
    }
}
