//
//  MockedMainDBRepository.swift
//  TTLangTests
//
//  Created by Yannis Lang on 20/03/2025.
//

import Foundation
@testable import TTLang
import SwiftData

// MARK: - PostsDBRepository

final class MockedPostsDBRepository: Mock, PostsDBRepository {
    enum Action: Equatable {
        case store([APIModel.Post])
        case get
        case removeAll
    }
    var actions = MockActions<Action>(expected: [])
    
    var storeResponses: [Result<Void, Error>] = []
    var getResponses: [Result<[DBModel.Post], Error>] = []
    var removeAllResponses: [Result<Void, Error>] = []
    
    func store(posts: [APIModel.Post]) async throws {
        register(.store(posts))
        guard !storeResponses.isEmpty else { throw MockError.valueNotSet }
        return try storeResponses.removeFirst().get()
    }
    
    func get() throws -> [DBModel.Post] {
        register(.get)
        guard !getResponses.isEmpty else { throw MockError.valueNotSet }
        return try getResponses.removeFirst().get()
    }
    
    func removeAll() async throws {
        register(.removeAll)
        guard !removeAllResponses.isEmpty else { throw MockError.valueNotSet }
        return try removeAllResponses.removeFirst().get()
    }
}

// MARK: - CommentsDBRepository

final class MockedCommentsDBRepository: Mock, CommentsDBRepository {
    enum Action: Equatable {
        case store([APIModel.Comment])
        case getComments(DBModel.Post)
        case remove(DBModel.Post)
    }
    var actions = MockActions<Action>(expected: [])
    
    var storeResponses: [Result<Void, Error>] = []
    var getCommentsResponses: [Result<[DBModel.Comment], Error>] = []
    var removeResponses: [Result<Void, Error>] = []
    
    func store(comments: [APIModel.Comment], for post: DBModel.Post) async throws {
        register(.store(comments))
        guard !storeResponses.isEmpty else { throw MockError.valueNotSet }
        return try storeResponses.removeFirst().get()
    }
    
    func getComments(for post: DBModel.Post) throws -> [DBModel.Comment] {
        register(.getComments(post))
        guard !getCommentsResponses.isEmpty else { throw MockError.valueNotSet }
        return try getCommentsResponses.removeFirst().get()
    }
    
    func remove(for post: DBModel.Post) async throws {
        register(.remove(post))
        guard !removeResponses.isEmpty else { throw MockError.valueNotSet }
        return try removeResponses.removeFirst().get()
    }
}
