import Foundation

#if DEBUG

@MainActor
extension APIModel.Comment {
    static let mockedData: [APIModel.Comment] = [
        .init(id: 1, message: "It looks great !", postID: 1, date: 1742487309, author: .mockedData[2]),
        .init(id: 2, message: "Nice !", postID: 2, date: 1742488309, author: .mockedData[2]),
        .init(id: 3, message: "Very nice", postID: 2, date: 1742488309, author: .mockedData[2])
    ]
    
    static func mockedData(for post: DBModel.Post) -> [APIModel.Comment] {
        mockedData.filter{ $0.postID == post.id }
    }
}

@MainActor
extension APIModel.Post {
    static let mockedData: [APIModel.Post] = [
        .init(id: 1, mediaURL: "https://videos.pexels.com/video-files/30775907/13164206_360_640_30fps.mp4", author: .mockedData[0], message: "First day in london", date: 1742488309, commentsCount: 1, likesCount: 5),
        .init(id: 2, mediaURL: "https://videos.pexels.com/video-files/17169505/17169505-hd_1080_1920_30fps.mp4", author: .mockedData[1], message: "Nice bike !", date: 1742488309, commentsCount: 2, likesCount: 12)
    ]
}

@MainActor
extension APIModel.User {
    static let mockedData: [APIModel.User] = [
        .init(id: 1, name: "Yannis"),
        .init(id: 2, name: "Titi"),
        .init(id: 3, name: "Toto")
    ]
}

struct FakePostsWebRepository: PostsRepository {
    func getComments(for post: DBModel.Post) async throws -> [APIModel.Comment] {
        await APIModel.Comment.mockedData(for: post)
    }
    
    func getFeedPosts(page: Int = 0, limit: Int = 2) async throws -> [APIModel.Post] {
        let postSize = await APIModel.Post.mockedData.count
        let userSize = await APIModel.User.mockedData.count
        return await APIModel.Post.mockedData.map{ APIModel.Post(id: $0.id + (postSize * page), mediaURL: $0.mediaURL, author: APIModel.User(id: $0.author.id + (userSize * page), name: $0.author.name), message: $0.message, date: Int(Date().timeIntervalSince1970) + $0.id + page, commentsCount: $0.commentsCount, likesCount: $0.likesCount) }
    }
}

#endif
