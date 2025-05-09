//
//  PostsDBRepository.swift
//  TTLang
//
//  Created by Yannis Lang on 20/03/2025.
//

import SwiftData
import Foundation

protocol PostsDBRepository {
    func store(posts: [APIModel.Post]) async throws
    @MainActor
    func get() throws -> [DBModel.Post]
    func removeAll() async throws
}

extension MainDBRepository: PostsDBRepository {
    func store(posts: [APIModel.Post]) async throws {
        try modelContext.transaction {
            posts.forEach { post in
                if let postDB = post.dbModel() {
                    modelContext.insert(postDB)
                }
            }
        }
    }
    
    @MainActor
    func get() throws -> [DBModel.Post] {
        try modelContainer.mainContext.fetch(FetchDescriptor<DBModel.Post>(sortBy: [.init(\.date)]))
    }
    
    func removeAll() async throws {
        try modelContext.transaction {
            try modelContext.delete(model: DBModel.Post.self)
        }
    }
}

extension APIModel.Post {
    func dbModel() -> DBModel.Post? {
        guard let mediaURL = URL(string: self.mediaURL) else {
            return nil
        }
        return .init(id: self.id, mediaURL: mediaURL, author: self.author.dbModel(), message: self.message, date: Date(timeIntervalSince1970: TimeInterval(self.date)), commentsCount: self.commentsCount, likesCount: self.likesCount)
    }
}

extension APIModel.User {
    func dbModel() -> DBModel.User {
        .init(id: self.id, name: self.name)
    }
}
