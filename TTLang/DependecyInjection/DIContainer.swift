//
//  DIContainer.swift
//  TTLang
//
//  Created by Yannis Lang on 20/03/2025.
//

import SwiftUI

struct DIContainer {
    var interactors: Interactors
    
    init(interactors: Interactors) {
        self.interactors = interactors
    }
}

extension DIContainer {
    
    struct WebRepositories {
        let posts: PostsRepository
    }
    
    struct DBRepositories {
        let posts: PostsDBRepository
        let comments: CommentsDBRepository
    }
    
    class Interactors {
        let posts: PostsInteractor
        
        init(posts: PostsInteractor) {
            self.posts = posts
        }
        
        static var stub: Interactors {
            .init(posts: StubPostsInteractor())
        }
    }
}

//MARK: Inject DIContaioner Environnement

extension EnvironmentValues {
    @Entry var injected: DIContainer = DIContainer(interactors: .stub)
}

extension View {
    func inject(_ container: DIContainer) -> some View {
        return self
            .environment(\.injected, container)
    }
}
