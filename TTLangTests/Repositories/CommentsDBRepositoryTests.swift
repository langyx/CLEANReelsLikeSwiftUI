//
//  CommentsDBRepositoryTests.swift
//  TTLangTests
//
//  Created by Yannis Lang on 20/03/2025.
//

import SwiftData
import Testing
@testable import TTLang
import Foundation

@MainActor
@Suite struct CommentsDBRepositoryTests {
    let modelContainer: ModelContainer
    let sut: CommentsDBRepository
    
    init() {
        self.modelContainer = .mock
        self.sut = MainDBRepository(modelContainer: modelContainer)
    }
    
    @Test func successStoreComments() async throws {
        let mockPost = APIModel.Post.mockedData.first!.dbModel()!
        let mockedComments = APIModel.Comment.mockedData(for: mockPost)
        try await sut.store(comments: mockedComments, for: mockPost)
        let results = try modelContainer.mainContext.fetch(DBModel.Comment.fetchDescriptor(for: mockPost))
        #expect(results.count == mockedComments.count)
    }
    
    @Test func successGetComments() async throws {
        let mockPost = APIModel.Post.mockedData.first!.dbModel()!
        let mockedComments = APIModel.Comment.mockedData(for: mockPost)
        try await sut.store(comments: mockedComments, for: mockPost)
        let results = try #require(try sut.getComments(for: mockPost))
        #expect(results.count == mockedComments.count)
    }
    
    @Test func succesRemoveComments() async throws {
        let mockPost = APIModel.Post.mockedData.first!.dbModel()!
        let mockedComments = APIModel.Comment.mockedData(for: mockPost)
        try await sut.store(comments: mockedComments, for: mockPost)
        try #require(!(try sut.getComments(for: mockPost).isEmpty))
        try await sut.remove(for: mockPost)
        let result = try sut.getComments(for: mockPost)
        #expect(result.count == 0)
    }
}
