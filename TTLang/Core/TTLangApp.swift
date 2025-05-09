//
//  TTLangApp.swift
//  TTLang
//
//  Created by Yannis Lang on 20/03/2025.
//

import SwiftUI
import SwiftData

@main
struct TTLangApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            appDelegate.rootView
        }
    }
}

extension AppEnvironment {
    var rootView: some View {
        VStack {
            if isRunningTests {
                Text("Running unit tests")
            } else {
                FeedView()
                    .modelContainer(modelContainer)
                    .inject(diContainer)
                if modelContainer.isStub {
                    Text("⚠️ There is an issue with local database")
                        .font(.caption2)
                }
            }
        }
    }
}
