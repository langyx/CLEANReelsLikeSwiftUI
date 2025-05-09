//
//  PostsWebRepository.swift
//  TTLang
//
//  Created by Yannis Lang on 20/03/2025.
//

import Foundation

protocol PostsRepository {
    func getFeedPosts(page: Int, limit: Int) async throws -> [APIModel.Post]
    func getComments(for post: DBModel.Post) async throws -> [APIModel.Comment]
}

struct PostsWebRepository: WebRepository, PostsRepository {
    var session: URLSession
    var baseURL: String
    
    init(session: URLSession, baseURL: String) {
        self.session = session
        self.baseURL = baseURL
    }
    
    func getFeedPosts(page: Int = 0, limit: Int = 5) async throws -> [APIModel.Post] {
        try await call(endpoint: API.getFeed(page: page, limit: limit))
    }
    
    func getComments(for post: DBModel.Post) async throws -> [APIModel.Comment] {
        try await call(endpoint: API.postComments(postID: post.id))
    }
}

// MARK: - Endpoints

extension PostsWebRepository {
    enum API {
        case getFeed(page: Int, limit: Int)
        case postComments(postID: Int)
    }
}

extension PostsWebRepository.API: APICall {
    var parameters: [URLQueryItem]? {
        switch self {
        case let .postComments(postID):
            return [.init(name: "post_id", value: "\(postID)")]
        case let .getFeed(page, limit):
            return [.init(name: "page", value: "\(page)"),
                    .init(name: "limit", value: "\(limit)")]
        }
    }
    
    var path: String {
        switch self {
        case .getFeed:
            "feed"
        case .postComments(_):
            "comments"
        }
    }
    var method: String {
        return "GET"
    }
    var headers: [String: String]? {
        return ["Accept": "application/json"]
    }
    func body() throws -> Data? {
        return nil
    }
}

