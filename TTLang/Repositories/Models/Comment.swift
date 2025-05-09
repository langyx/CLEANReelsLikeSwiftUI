//
//  Comment.swift
//  TTLang
//
//  Created by Yannis Lang on 20/03/2025.
//

import SwiftData
import Foundation

// MARK: - Database Model

extension DBModel {
    @Model
    class Comment {
        var id: Int
        var message: String
        var date: Date
        
        var author: User?
        
        var post: Post
        
        init(id: Int, message: String, date: Date, author: User, post: Post) {
            self.id = id
            self.message = message
            self.date = date
            self.author = author
            self.post = post
        }
    }
}

// MARK: - Web API Model

extension APIModel {
    struct Comment: Codable, Equatable {
        var id: Int
        var message: String
        var postID: Int
        var date: Int
        var author: User
        
        enum CodingKeys: String, CodingKey {
            case id, message, postID = "post_id", date, author
        }
    }
}
