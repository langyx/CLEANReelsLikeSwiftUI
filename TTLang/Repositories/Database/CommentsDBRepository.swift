//
//  CommentsDBRepository.swift
//  TTLang
//
//  Created by Yannis Lang on 20/03/2025.
//

import Foundation
import SwiftData

protocol CommentsDBRepository {
    func store(comments: [APIModel.Comment], for post: DBModel.Post) async throws
    @MainActor
    func getComments(for post: DBModel.Post) throws -> [DBModel.Comment]
    func remove(for post: DBModel.Post) async throws
}

extension MainDBRepository: CommentsDBRepository {
    func store(comments: [APIModel.Comment], for post: DBModel.Post) async throws {
        try modelContext.transaction {
            comments.forEach { comment in
                modelContext.insert(comment.dbModel(for: post))
            }
        }
    }
    
    @MainActor
    func getComments(for post: DBModel.Post) throws -> [DBModel.Comment] {
        try modelContainer.mainContext.fetch(DBModel.Comment.fetchDescriptor(for: post))
    }
    
    func remove(for post: DBModel.Post) async throws {
        let postID = post.id
        try modelContext.delete(model: DBModel.Comment.self, where: #Predicate<DBModel.Comment> {
            $0.post.id == postID
        })
        post.comments = []
    }
}

extension DBModel.Comment {
    static func fetchDescriptor(for post: DBModel.Post) -> FetchDescriptor<DBModel.Comment> {
        let postID = post.id
        return FetchDescriptor(predicate: #Predicate<DBModel.Comment> {
            $0.post.id == postID
        }, sortBy: [.init(\.date)])
    }
}

extension APIModel.Comment {
    func dbModel(for post: DBModel.Post) -> DBModel.Comment {
        .init(id: self.id, message: self.message, date: Date(timeIntervalSince1970: TimeInterval(self.date)), author: author.dbModel(), post: post)
    }
}
