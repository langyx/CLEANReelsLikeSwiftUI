//
//  PostsInteractorTests.swift
//  TTLangTests
//
//  Created by Yannis Lang on 20/03/2025.
//

import Testing
import SwiftUI
@testable import TTLang

@MainActor
@Suite class PostsInteractorTests {

    let mockedWebRepo: MockedPostsWebRepository
    let mockedPostsDBRepo: MockedPostsDBRepository
    let mockedCommentsDBRepo: MockedCommentsDBRepository
    let sut: ImpPostsInteractor

    init() {
        mockedWebRepo = MockedPostsWebRepository()
        mockedPostsDBRepo = MockedPostsDBRepository()
        mockedCommentsDBRepo = MockedCommentsDBRepository()
        sut = ImpPostsInteractor(postsDBRepository: mockedPostsDBRepo, postsWebRepository: mockedWebRepo, commentsDBRepository: mockedCommentsDBRepo)
    }
}

// MARK: - refresh()

final class RefreshPostsTests: PostsInteractorTests {

    @Test func successPath() async throws {
        let mockedPosts = APIModel.Post.mockedData
        mockedWebRepo.actions = .init(expected: [
            .getFeedPosts
        ])
        mockedWebRepo.getFeedPostsResponses = [
            .success(mockedPosts)
        ]
        mockedPostsDBRepo.actions = .init(expected: [
            .removeAll,
            .store(mockedPosts)
        ])
        mockedPostsDBRepo.removeAllResponses = [
            .success(())
        ]
        mockedPostsDBRepo.storeResponses = [
            .success(())
        ]
        try await sut.refresh()
        mockedWebRepo.verify()
        mockedPostsDBRepo.verify()
    }

    @Test func dbFailure() async throws {
        let mockedPosts = APIModel.Post.mockedData
        mockedWebRepo.actions = .init(expected: [
            .getFeedPosts
        ])
        mockedWebRepo.getFeedPostsResponses = [
            .success(mockedPosts)
        ]
        mockedPostsDBRepo.actions = .init(expected: [
            .removeAll,
            .store(mockedPosts)
        ])
        let error = NSError.test
        mockedPostsDBRepo.removeAllResponses = [.success(())]
        mockedPostsDBRepo.storeResponses = [.failure(error)]
        await #expect(throws: error) {
            try await sut.refresh()
        }
        mockedWebRepo.verify()
        mockedPostsDBRepo.verify()
    }

    @Test func webFailure() async throws {
        mockedWebRepo.actions = .init(expected: [
            .getFeedPosts
        ])
        let error = NSError.test
        mockedWebRepo.getFeedPostsResponses = [
            .failure(error)
        ]
        mockedPostsDBRepo.actions = .init(expected: [.removeAll])
        mockedPostsDBRepo.removeAllResponses = [.success(())]
        await #expect(throws: error) {
            try await sut.refresh()
        }
        mockedWebRepo.verify()
        mockedPostsDBRepo.verify()
    }
}

// MARK: - refreshComments()

final class RefreshCommentsTests: PostsInteractorTests {
    @Test func successPath() async throws {
        let mockedPost = APIModel.Post.mockedData.first!.dbModel()!
        let mockedComments = APIModel.Comment.mockedData(for: mockedPost)
        mockedWebRepo.actions = .init(expected: [
            .postComments(post: mockedPost)
        ])
        mockedWebRepo.postCommentsResponses = [.success(mockedComments)]
        mockedCommentsDBRepo.actions = .init(expected: [
            .remove(mockedPost),
            .store(mockedComments)
        ])
        mockedCommentsDBRepo.removeResponses = [.success(())]
        mockedCommentsDBRepo.storeResponses = [.success(())]
        try await sut.refreshComments(for: mockedPost)
        mockedWebRepo.verify()
        mockedCommentsDBRepo.verify()
    }
}
