//
//  WebRepository.swift
//  TTLang
//
//  Created by Yannis Lang on 20/03/2025.
//

import Foundation
import Combine

enum APIModel {}

protocol WebRepository {
    var session: URLSession { get }
    var baseURL: String { get }
}

// MARK: - APICall

extension WebRepository {
    func call<Value, Decoder>(
        endpoint: APICall,
        decoder: Decoder = JSONDecoder(),
        httpCodes: HTTPCodes = .success,
        requestModifier: ((URLRequest) throws -> URLRequest)? = nil
    ) async throws -> Value
    where Value: Decodable, Decoder: TopLevelDecoder, Decoder.Input == Data {

        var request = try endpoint.urlRequest(baseURL: baseURL)
        if let requestModifier {
            request = try requestModifier(request)
        }
        let (data, response) = try await session.data(for: request)
        guard let code = (response as? HTTPURLResponse)?.statusCode else {
            throw APIError.unexpectedResponse
        }
        guard httpCodes.contains(code) else {
            throw APIError.httpCode(code)
        }
        do {
            return try decoder.decode(Value.self, from: data)
        } catch {
            debugPrint(error)
            throw APIError.unexpectedResponse
        }
    }
}

// MARK: - APICall

protocol APICall {
    var path: String { get }
    var method: String { get }
    var headers: [String: String]? { get }
    var parameters: [URLQueryItem]? { get }
    func body() throws -> Data?
}

enum APIError: Swift.Error, Equatable {
    case invalidURL
    case httpCode(HTTPCode)
    case unexpectedResponse
    case imageDeserialization
}

extension APIError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL: return "Invalid URL"
        case let .httpCode(code): return "Unexpected HTTP code: \(code)"
        case .unexpectedResponse: return "Unexpected response from the server"
        case .imageDeserialization: return "Cannot deserialize image from Data"
        }
    }
}

extension APICall {
    func urlRequest(baseURL: String) throws -> URLRequest {
        var url = URLComponents(string: baseURL + path)
        url?.queryItems = parameters
        guard let url = url?.url else {
            throw APIError.invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.allHTTPHeaderFields = headers
        request.httpBody = try body()
        return request
    }
}

typealias HTTPCode = Int
typealias HTTPCodes = Range<HTTPCode>

extension HTTPCodes {
    static let success = 200 ..< 300
}
