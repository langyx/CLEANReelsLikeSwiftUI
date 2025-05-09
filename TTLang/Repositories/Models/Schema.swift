//
//  Schema.swift
//  TTLang
//
//  Created by Yannis Lang on 20/03/2025.
//

import SwiftData

enum DBModel { }

extension Schema {
    private static var actualVersion: Schema.Version = Version(1, 0, 0)

    static var appSchema: Schema {
        Schema([
            DBModel.Comment.self,
            DBModel.User.self,
            DBModel.Post.self
        ], version: actualVersion)
    }
}
