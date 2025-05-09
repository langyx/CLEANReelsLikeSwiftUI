//
//  FeedView.swift
//  TTLang
//
//  Created by Yannis Lang on 19/03/2025.
//

import SwiftUI
import SwiftData

struct FeedView: View {
    @Environment(\.injected) private var injected: DIContainer
    
    @Query(sort: \DBModel.Post.date, order: .forward) var posts: [DBModel.Post]
    @State private(set) var postsState: Loadable<Void> = .notRequested
    @State private(set) var postsUpdateState: Loadable<Void> = .notRequested
    
    @State private var visiblePostsIndexes: [Int] = []
    @State private var currentPage = 0
    private let limit = 10
    
    init() {
        _posts = Query(filter: #Predicate<DBModel.Post> {
            $0.seen == false
        }, sort: [.init(\DBModel.Post.date, order: .forward)])
    }
    
    var body: some View {
        content
            .preferredColorScheme(.dark)
    }
    
    @ViewBuilder var content: some View {
        switch postsState {
        case .notRequested:
            defaultView()
        case .isLoading(_, _):
            loadingView()
        case .loaded(_):
            loadedView()
        case .failed(let error):
            failedView(error)
        }
    }
}

// MARK: - Loading Content

private extension FeedView {
    func defaultView() -> some View {
        Text("").onAppear {
            loadPosts()
        }
    }
    
    func loadingView() -> some View {
        ProgressView()
            .progressViewStyle(CircularProgressViewStyle())
    }
    
    func failedView(_ error: Error) -> some View {
        ContentUnavailableView {
            Label(error.localizedDescription, systemImage: "play.slash.fill")
        } actions: {
            Button("Retry") {
                loadPosts()
            }
        }
    }
}

// MARK: - Side Effects

private extension FeedView {
    private func loadPosts() {
        $postsState.load {
            try await injected.interactors.posts.refresh(page: currentPage, limit: limit, force: true)
            currentPage += 1
        }
    }
    
    private func updatePosts() {
        $postsUpdateState.load {
            try await injected.interactors.posts.refresh(page: currentPage, limit: limit, force: false)
            currentPage += 1
        }
    }
}

// MARK: - Displaying Content

@MainActor
private extension FeedView {
    @ViewBuilder
    func loadedView() -> some View {
        GeometryReader { prox in
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(spacing: 0) {
                    ForEach(posts.indices, id: \.self) { i in
                        FeedPost(post: posts[i], isVisible: isVisible(postIndex: i))
                            .frame(width: prox.size.width, height: prox.size.height)
                            .overlay {
                                FeedPostControls(post: posts[i])
                            }
                    }
                }
            }
            .scrollTargetLayout()
        }
        .scrollTargetBehavior(.paging)
        .onScrollTargetVisibilityChange(idType: Int.self) { identifiers in
            visiblePostsIndexes = identifiers
            if visiblePostsIndexes.contains(posts.count - 1) {
                updatePosts()
            }
        }
        .ignoresSafeArea()
    }
    
    func isVisible(postIndex: Int) -> Bool {
        guard !visiblePostsIndexes.isEmpty else {
            return true
        }
        return visiblePostsIndexes.contains(postIndex)
    }
}

#Preview {
    EnvironmentPreviewWrapper {
        FeedView()
    }
}

