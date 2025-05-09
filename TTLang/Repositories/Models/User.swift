//
//  User.swift
//  TTLang
//
//  Created by Yannis Lang on 20/03/2025.
//

import SwiftData


// MARK: - Database Model

extension DBModel {
    @Model
    class User {
        var id: Int
        var name: String
        
        init(id: Int, name: String) {
            self.id = id
            self.name = name
        }
    }
}

// MARK: - Web API Model

extension APIModel {
    struct User: Codable, Equatable {
        var id: Int
        var name: String
        
        enum CodingKeys: String, CodingKey {
            case id, name
        }
    }
}
