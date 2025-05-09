//
//  AppEnvironment.swift
//  TTLang
//
//  Created by Yannis Lang on 20/03/2025.
//


import Foundation
import SwiftData

struct AppEnvironment {
    let isRunningTests: Bool
    let diContainer: DIContainer
    let modelContainer: ModelContainer
}

extension AppEnvironment {
    @MainActor static func bootstrap(isPreview: Bool = false) -> AppEnvironment {
        let modelContainer = configuredModelContainer(isPreview: isPreview)
       
        let session = configuredURLSession()
        let dbRepositories = configuredDBRepositories(modelContainer: modelContainer)
        let webRepositories = configuredWebRepositories(session: session)
        let interactors = configuredInteractors(webRepositories: webRepositories, dbRepositories: dbRepositories)
        let diContainer = DIContainer(interactors: interactors)
        
        return AppEnvironment(
            isRunningTests: ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil,
            diContainer: diContainer,
            modelContainer: modelContainer
        )
    }
}

extension AppEnvironment {
    private static func configuredURLSession() -> URLSession {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 60
        configuration.timeoutIntervalForResource = 120
        configuration.waitsForConnectivity = true
        configuration.httpMaximumConnectionsPerHost = 5
        configuration.requestCachePolicy = .returnCacheDataElseLoad
        configuration.urlCache = .shared
        return URLSession(configuration: configuration)
    }
    
    private static func configuredWebRepositories(session: URLSession) -> DIContainer.WebRepositories {
#warning("update url")
        return .init(posts: FakePostsWebRepository())//PostsWebRepository(session: session, baseURL: ""))
    }
    
    private static func configuredDBRepositories(modelContainer: ModelContainer) -> DIContainer.DBRepositories {
        let mainDB = MainDBRepository(modelContainer: modelContainer)
        return .init(posts: mainDB, comments: mainDB)
    }
    
    private static func configuredModelContainer(isPreview: Bool = false) -> ModelContainer {
        do {
            return try ModelContainer.appModelContainer(inMemoryOnly: isPreview, isStub: isPreview)
        } catch {
            debugPrint(error)
            return ModelContainer.stub
        }
    }
    
    private static func configuredInteractors(
            webRepositories: DIContainer.WebRepositories,
            dbRepositories: DIContainer.DBRepositories
        ) -> DIContainer.Interactors {
            let postsInteractor = ImpPostsInteractor(postsDBRepository: dbRepositories.posts, postsWebRepository: webRepositories.posts, commentsDBRepository: dbRepositories.comments)
            return .init(posts: postsInteractor)
        }
}
