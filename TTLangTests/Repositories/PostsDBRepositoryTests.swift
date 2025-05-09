//
//  PostsDBRepositoryTests.swift
//  TTLangTests
//
//  Created by Yannis Lang on 20/03/2025.
//

import SwiftData
import Testing
@testable import TTLang

@MainActor
@Suite struct PostsDBRepositoryTests {
    let modelContainer: ModelContainer
    let sut: PostsDBRepository
    
    init() {
        self.modelContainer = .mock
        self.sut = MainDBRepository(modelContainer: modelContainer)
    }
    
    @Test func successStorePosts() async throws {
        let mockedData = APIModel.Post.mockedData
        try await sut.store(posts: mockedData)
        let results = try modelContainer.mainContext.fetch(FetchDescriptor<DBModel.Post>())
        #expect(results.count == mockedData.count)
    }
    
    @Test func badMediaURLStorePosts() async throws {
        var mockedData = APIModel.Post.mockedData
        mockedData[0].mediaURL = ""
        try await sut.store(posts: mockedData)
        let results = try modelContainer.mainContext.fetch(FetchDescriptor<DBModel.Post>())
        #expect(results.count == mockedData.count - 1)
    }
    
    @Test func successGetPosts() async throws {
        let mockedData = APIModel.Post.mockedData
        try await sut.store(posts: mockedData)
        let stored = try #require(try await sut.get())
        #expect(stored.count == mockedData.count)
    }
    
    @Test func succesRemoveAll() async throws {
        try await sut.store(posts: APIModel.Post.mockedData)
        try #require(!(try sut.get().isEmpty))
        try await sut.removeAll()
        let result = try modelContainer.mainContext.fetch(FetchDescriptor<DBModel.Post>())
        #expect(result.isEmpty)
    }
}
