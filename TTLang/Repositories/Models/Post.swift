//
//  Untitled.swift
//  TTLang
//
//  Created by Yannis Lang on 20/03/2025.
//

import SwiftData
import Foundation


// MARK: - Database Model

extension DBModel {
    @Model
    class Post {
        var id: Int
        var mediaURL: URL
        var author: User?
        var message: String
        var date: Date
        var commentsCount: Int
        var likesCount: Int
        
        var liked = false
        var seen = false
       
        var comments: [Comment] = []
        
        init(id: Int, mediaURL: URL, author: User? = nil, message: String, date: Date, commentsCount: Int, likesCount: Int) {
            self.id = id
            self.mediaURL = mediaURL
            self.author = author
            self.message = message
            self.date = date
            self.commentsCount = commentsCount
            self.likesCount = likesCount
        }
    }
}

// MARK: - Web API Model

extension APIModel {
    struct Post: Codable, Equatable {
        var id: Int
        var mediaURL: String
        var author: User
        var message: String
        var date: Int
        var commentsCount: Int
        var likesCount: Int
        
        enum CodingKeys: String, CodingKey {
            case id, mediaURL = "media_url", author, message, date, commentsCount, likesCount
        }
    }
}
