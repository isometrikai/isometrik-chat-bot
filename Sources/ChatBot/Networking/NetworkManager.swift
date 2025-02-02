// Copyright © SnapNews. All rights reserved.

import Foundation

public protocol NetworkManagable {
    func getDecodedData<T: Decodable>(apiModel: APIModelType) async throws -> T
    func getData(apiModel: APIModelType) async throws -> Data
}

public enum NetworkError: Error {
    case decodingError(Error)
    case incorrectURL
    case unknown
    case noResponse
    case unauthorized
    case timeout
}

extension NetworkError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .decodingError(let error):
            return "Decoding Error: \(error.localizedDescription)"
        case .incorrectURL:
            return NSLocalizedString("Incorrect URL", comment: "")
        case .unknown:
            return NSLocalizedString("Unknown Error", comment: "")
        case .noResponse:
            return NSLocalizedString("No Response from Server", comment: "")
        case .unauthorized:
            return NSLocalizedString("Unauthorized Access", comment: "")
        case .timeout:
            return NSLocalizedString("Request time out!", comment: "")
        }
    }
}

/// Helper class to prepare request(adding headers & clubbing base URL) & perform API request.
public class NetworkManager: NetworkManagable {
    public init() {}

    public func getDecodedData<T: Decodable>(apiModel: APIModelType) async throws -> T {
        do {
            let response = try await getData(apiModel: apiModel)
            do {
                let decodableModel: T = try await JSONResponseDecoder.decode(response)
                return decodableModel
            } catch let decodableError {
                throw NetworkError.decodingError(decodableError)
            }
        }
    }

    public func getData(apiModel: APIModelType) async throws -> Data {
        let escapedAddress = (apiModel.api.apiBasePath() + apiModel.api.apiEndPath()).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        var url = URL(string: escapedAddress!)!
        url.append(queryItems: apiModel.queryParameters?.compactMap { URLQueryItem(name: $0.key, value: $0.value) } ?? [])
        var request = URLRequest(url: url)
        request.httpMethod = apiModel.api.httpMthodType().rawValue

        var commonHeaders = ServiceConfig().generateHeader()
        let additionalHeader = apiModel.api.additionalHeader()
        commonHeaders.merge(additionalHeader) { _, new in new }
        request.allHTTPHeaderFields = commonHeaders

        if let params = apiModel.parameters {
            request.httpBody = try JSONSerialization.data(withJSONObject: params as Any, options: .prettyPrinted)
        }

        request.timeoutInterval = apiModel.api.timeout

        do {
            let (data, response) = try await URLSession.shared.data(for: request, delegate: nil)
            guard let response = response as? HTTPURLResponse else {
                ISMChatBotLogManager.shared.logFailureEvents(request: request, status: 0, data: data)
                throw NetworkError.noResponse
            }

            switch response.statusCode {
            case 200 ... 299:
                ISMChatBotLogManager.shared.logSuccessEvents(request: request, status: response.statusCode, responseData: data)
                return data
            case 400, 401, 406:
                ISMChatBotLogManager.shared.logFailureEvents(request: request, status: response.statusCode, data: data)
                throw NetworkError.unauthorized
            default:
                ISMChatBotLogManager.shared.logFailureEvents(request: request, status: response.statusCode, data: data)
                throw NetworkError.unknown
            }
        } catch let error as URLError where error.code == .timedOut {
            // Handle timeout error specifically
            throw NetworkError.timeout
        } catch let error as NetworkError {
            // Handle other errors
            throw error
        }
    }
}
