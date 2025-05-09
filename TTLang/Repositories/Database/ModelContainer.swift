//
//  ModelContainer.swift
//  TTLang
//
//  Created by Yannis Lang on 20/03/2025.
//

import SwiftData

extension ModelContainer {

    static func appModelContainer(
        inMemoryOnly: Bool = false, isStub: Bool = false
    ) throws -> ModelContainer {
        let schema = Schema.appSchema
        let modelConfiguration = ModelConfiguration(isStub ? "stub" : nil, schema: schema, isStoredInMemoryOnly: inMemoryOnly)
        return try ModelContainer(for: schema, configurations: [modelConfiguration])
    }

    static var stub: ModelContainer {
        try! appModelContainer(inMemoryOnly: true, isStub: true)
    }

    var isStub: Bool {
        return configurations.first?.name == "stub"
    }
}

@ModelActor
final actor MainDBRepository { }
