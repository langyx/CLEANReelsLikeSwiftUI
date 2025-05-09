//
//  PostsInteractor.swift
//  PreTest
//
//  Created by Yannis Lang on 19/03/2025.
//

import Foundation

protocol PostsInteractor {
    func refresh(page: Int, limit: Int, force: Bool) async throws
    func refreshComments(for post: DBModel.Post) async throws
}

struct ImpPostsInteractor: PostsInteractor {
    let postsDBRepository: PostsDBRepository
    let postsWebRepository: PostsRepository
    let commentsDBRepository: CommentsDBRepository
    
    func refresh(page: Int = 0, limit: Int = 2, force: Bool = true) async throws {
        if force {
            try await postsDBRepository.removeAll()
        }
        let posts = try await postsWebRepository.getFeedPosts(page: page, limit: limit)
        try await postsDBRepository.store(posts: posts)
    }
    
    func refreshComments(for post: DBModel.Post) async throws {
        try await commentsDBRepository.remove(for: post)
        let comments = try await postsWebRepository.getComments(for: post)
        try await commentsDBRepository.store(comments: comments, for: post)
    }
}

struct StubPostsInteractor: PostsInteractor {
    func refreshComments(for post: DBModel.Post) async throws -> [DBModel.Comment] {
        []
    }
    
    func refreshComments(for post: DBModel.Post) async throws {
    }
    
    func refresh(page: Int, limit: Int = 2, force: Bool = true) async throws {
    }
}
