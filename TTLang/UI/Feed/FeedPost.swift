//
//  FeedPost.swift
//  TTLang
//
//  Created by Yannis Lang on 20/03/2025.
//

import SwiftUI

struct FeedPost: View {
    @State private var showComment = false
    
    var post: DBModel.Post
    var isVisible: Bool
    
    var body: some View {
        VideoPlayerView(isPlaying: isVisible, url: post.mediaURL)
    }
}

#Preview {
    FeedPost(post: APIModel.Post.mockedData[1].dbModel()!, isVisible: true)
}
