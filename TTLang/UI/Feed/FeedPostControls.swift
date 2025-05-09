//
//  FeedControls.swift
//  TTLang
//
//  Created by Yannis Lang on 20/03/2025.
//

import SwiftUI

struct FeedPostControls: View {
    @State private var showComments = false
    
    var post: DBModel.Post
    
    var body: some View {
        VStack(alignment: .trailing) {
            Spacer()
            actions
            informations
        }
        .padding(30)
    }

    var informations: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(post.author?.name ?? "")
                    .font(.headline)
                Text(post.message)
                    .font(.subheadline)
            }
            Spacer()
        }
    }
    
    var actions: some View {
        VStack(alignment: .center, spacing: 15) {
            Button("\(post.likesCount)", systemImage: "heart\(post.liked ? ".fill" : "")") {
                post.liked.toggle()
                post.likesCount += post.liked ? 1 : -1
            }
            Button("\(post.commentsCount)", systemImage: "message.fill") {
                showComments.toggle()
            }
            .sheet(isPresented: $showComments) {
                FeedPostComments(post: post)
                    .presentationDetents([.medium])
            }
        }
        .foregroundStyle(.white)
        .labelStyle(VerticalLabelStyle())
    }
}


#Preview {
    EnvironmentPreviewWrapper {
        FeedPostControls(post: APIModel.Post.mockedData.first!.dbModel()!)
    }
}
