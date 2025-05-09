//
//  FeedPostComments.swift
//  TTLang
//
//  Created by Yannis Lang on 20/03/2025.
//

import SwiftUI
import SwiftData

struct FeedPostComments: View {
    @Environment(\.injected) private var injected: DIContainer
    
    @Query(FetchDescriptor<DBModel.Comment>()) var comments: [DBModel.Comment]
    
    @State private(set) var commentsState: Loadable<Void> = .notRequested
    var post: DBModel.Post
    
    init(post: DBModel.Post) {
        self.post = post
        _comments = Query(DBModel.Comment.fetchDescriptor(for: post))
    }
    
    var body: some View {
        content
            .preferredColorScheme(.dark)
    }
    
    @ViewBuilder var content: some View {
        switch commentsState {
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

private extension FeedPostComments {
    func defaultView() -> some View {
        Text("").onAppear {
            loadComments()
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
                loadComments()
            }
        }
    }
}

// MARK: - Side Effects

private extension FeedPostComments {
    private func loadComments() {
        $commentsState.load {
            try await injected.interactors.posts.refreshComments(for: post)
        }
    }
}

// MARK: - Displaying Content

@MainActor
private extension FeedPostComments {
    @ViewBuilder
    func loadedView() -> some View {
        VStack(spacing: 20){
            RoundedRectangle(cornerRadius: 30)
                .foregroundStyle(.secondary)
                .containerRelativeFrame(.horizontal) { w, axis in
                    w * 0.15
                }
                .frame(maxHeight: 4)
                .padding(.top)
            Text("Comments")
                .font(.headline)
            if comments.isEmpty {
                noCommentView
            }else{
                ScrollView(showsIndicators: false) {
                    LazyVStack(alignment: .leading, spacing: 20){
                        ForEach(comments) { comment in
                            cell(for: comment)
                        }
                    }
                    .padding(.vertical)
                    .padding(.horizontal, 25)
                }
            }
        }
    }
    
    func cell(for comment: DBModel.Comment) -> some View {
        VStack(alignment: .leading) {
            HStack {
                Text(comment.author?.name ?? "")
                    .font(.subheadline.bold())
                Text(comment.date.timeOrDaySinceNow)
                    .foregroundStyle(.secondary)
                    .font(.footnote)
            }
            Text(comment.message)
                .font(.subheadline)
        }
    }
    
    var noCommentView: some View {
        ContentUnavailableView("No comment", systemImage: "ellipsis.message", description: Text("Be the first to write one !"))
    }
}


#Preview {
    EnvironmentPreviewWrapper {
        FeedPostComments(post: APIModel.Post.mockedData[1].dbModel()!)
    }
}
