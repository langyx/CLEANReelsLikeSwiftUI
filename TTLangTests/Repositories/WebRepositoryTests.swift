//
//  WebRepositoryTessts.swift
//  TTLangTests
//
//  Created by Yannis Lang on 20/03/2025.
//

import Testing
@testable import TTLang
import Foundation

@Suite(.serialized) final class WebRepositoryTests {
    private let sut = TestWebRepository()
    
    private typealias API = TestWebRepository.API
    typealias Mock = RequestMocking.MockedResponse
    
    deinit {
        RequestMocking.removeAllMocks()
    }
    
    @Test func loadSuccess() async throws {
        let data = TestWebRepository.TestData()
        try mock(.test, result: .success(data))
        let result = try await sut.load(.test)
        #expect(result == data)
    }
    
    @Test func loadParseError() async throws {
        let data = await APIModel.Comment.mockedData
        try mock(.test, result: .success(data))
        await #expect(throws: APIError.unexpectedResponse) {
            try await sut.load(.test)
        }
    }
    
    @Test func loadHttpCodeFailure() async throws {
        let data = TestWebRepository.TestData()
        try mock(.test, result: .success(data), httpCode: 500)
        await #expect(throws: APIError.httpCode(500)) {
            try await sut.load(.test)
        }
    }

    @Test func loadNetworkingError() async throws {
        let errorRef = NSError.test
        try mock(.test, result: Result<TestWebRepository.TestData, Error>.failure(errorRef))
        do {
            _ = try await sut.load(.test)
            Issue.record("Above should throw")
        } catch {
            let nsError = error as NSError
            #expect(nsError.domain == errorRef.domain)
            #expect(nsError.code == errorRef.code)
        }
    }

    @Test func loadRequestURLError() async {
        await #expect(throws: APIError.invalidURL) {
            try await sut.load(.urlError)
        }
    }

    @Test func loadRequestBodyError() async {
        await #expect(throws: TestWebRepository.APIError.fail) {
            try await sut.load(.bodyError)
        }
    }

    @Test func loadLoadableError() async {
        await #expect(throws: APIError.invalidURL) {
            try await sut.load(.urlError)
        }
    }

    @Test func loadNoHttpCodeError() async throws {
        let response = URLResponse(url: URL(fileURLWithPath: ""),
                                   mimeType: "example", expectedContentLength: 0, textEncodingName: nil)
        let mock = try Mock(apiCall: API.test, baseURL: sut.baseURL, customResponse: response)
        RequestMocking.add(mock: mock)
        await #expect(throws: APIError.unexpectedResponse) {
            try await sut.load(.test)
        }
    }
    
    @Test func requestWithParameters() async throws {
        let request = try API.testParameters(name: "toto").urlRequest(baseURL: sut.baseURL)
        let url = try #require(request.url)
        let queryItem = URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems?.first
        #expect(queryItem?.value == "toto")
    }
    
    private func mock<T>(_ apiCall: API, result: Result<T, Swift.Error>,
                         httpCode: HTTPCode = 200) throws where T: Encodable {
        let mock = try Mock(apiCall: apiCall, baseURL: sut.baseURL, result: result, httpCode: httpCode)
        RequestMocking.add(mock: mock)
    }
}

private extension TestWebRepository {
    func load(_ api: API) async throws -> TestData {
        try await call(endpoint: api)
    }
}

extension TestWebRepository {
    enum API: APICall {
        case test
        case testParameters(name: String)
        case urlError
        case bodyError
        case noHttpCodeError

        var path: String {
            switch self {
            case .urlError:
                return "\\"
            default:
                return "/test/path"
            }
        }
        var method: String { "POST" }
        var headers: [String: String]? { nil }
        var parameters: [URLQueryItem]? {
            switch self {
            case .testParameters(let name):
                return [.init(name: "name", value: name)]
            default:
                return nil
            }
        }
        func body() throws -> Data? {
            switch self {
            case .bodyError:
                throw APIError.fail
            default:
                return nil
            }
        }
    }
}

extension TestWebRepository {
    enum APIError: Swift.Error, LocalizedError {
        case fail
        var errorDescription: String? { "fail" }
    }
}

extension TestWebRepository {
    struct TestData: Codable, Equatable {
        let string: String
        let integer: Int

        init() {
            string = "some string"
            integer = 42
        }
    }
}
