//
//  PostsWebRepositoryTests.swift
//  TTLangTests
//
//  Created by Yannis Lang on 20/03/2025.
//

import Foundation
import Testing
@testable import TTLang

@MainActor
@Suite(.serialized) final class PostsWebRepositoryTests {
    private var sut = PostsWebRepository(session: .mockedResponsesOnly, baseURL: "http://test.com")
    
    typealias API = PostsWebRepository.API
    typealias Mock = RequestMocking.MockedResponse

    let mockedData = APIModel.Post.mockedData
    
    deinit {
        RequestMocking.removeAllMocks()
    }
    
    @Test func getFeedPostsSuccess() async throws {
        try mock(.getFeed, result: .success(mockedData))
        let response = try await sut.getFeedPosts()
        #expect(response.count == mockedData.count)
    }
    
    @Test func commentForPostSucces() async throws {
        let mockPost = mockedData[1].dbModel()!
        let mockedComments = APIModel.Comment.mockedData(for: mockPost)
        try mock(.postComments(postID: mockPost.id), result: .success(mockedComments))
        let response = try await sut.getComments(for: mockPost)
        #expect(response.count == mockedComments.count)
    }
    
    // MARK: - Helper

    private func mock<T>(_ apiCall: API, result: Result<T, Swift.Error>,
                         httpCode: HTTPCode = 200) throws where T: Encodable {
        let mock = try Mock(apiCall: apiCall, baseURL: sut.baseURL, result: result, httpCode: httpCode)
        RequestMocking.add(mock: mock)
    }
}
