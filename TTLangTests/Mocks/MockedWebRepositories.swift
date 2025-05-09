//
//  MockedWebRepositories.swift
//  TTLangTests
//
//  Created by Yannis Lang on 20/03/2025.
//

import Foundation
@testable import TTLang
import SwiftData

class TestWebRepository: WebRepository {
    var session: URLSession = .mockedResponsesOnly
    var baseURL = "https://test.com"
}

// MARK: - PostsWebRepository
final class MockedPostsWebRepository: TestWebRepository, PostsRepository, Mock {

    enum Action: Equatable {
        case getFeedPosts
        case postComments(post: DBModel.Post)
    }
    
    var actions = MockActions<Action>(expected: [])
    
    var getFeedPostsResponses: [Result<[APIModel.Post], Error>] = []
    var postCommentsResponses: [Result<[APIModel.Comment], Error>] = []
    
    func getFeedPosts(page: Int, limit: Int) async throws -> [APIModel.Post] {
        register(.getFeedPosts)
        guard !getFeedPostsResponses.isEmpty else { throw MockError.valueNotSet }
        return try getFeedPostsResponses.removeFirst().get()
    }
    
    func getComments(for post: DBModel.Post) async throws -> [APIModel.Comment] {
        register(.postComments(post: post))
        guard !postCommentsResponses.isEmpty else { throw MockError.valueNotSet }
        return try postCommentsResponses.removeFirst().get()
    }
}

extension ModelContainer {
    static var mock: ModelContainer {
        try! appModelContainer(inMemoryOnly: true, isStub: false)
    }
}



