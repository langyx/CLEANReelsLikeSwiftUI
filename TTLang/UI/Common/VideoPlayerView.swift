//
//  VideoPlayerView.swift
//  TTLang
//
//  Created by Yannis Lang on 20/03/2025.
//

import SwiftUI
import AVKit

@Observable
class VideoPlayerViewModel {
    var player: AVPlayer?
    
    func setupPlayer(with url: URL) {
        player = AVPlayer(url: url)
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime,
                                               object: player?.currentItem,
                                               queue: .main) { [weak self] _ in
            self?.player?.seek(to: .zero)
            self?.player?.play()
        }
    }
    
    func play() {
        player?.play()
    }
    
    func pause() {
        player?.pause()
    }
}

struct VideoPlayerView: View {
    @State private var playerViewModel = VideoPlayerViewModel()
    
    let isPlaying: Bool
    var url: URL
    
    
    init(isPlaying: Bool, url: URL) {
        self.isPlaying = isPlaying
        self.url = url
    }
    
    var body: some View {
        VStack {
            if let player = playerViewModel.player {
                VideoPlayer(player: player)
                .scaledToFill()
                .allowsHitTesting(false)
            }
        }
        .onAppear {
            playerViewModel.setupPlayer(with: url)
            if isPlaying {
                playerViewModel.play()
            }
        }
        .onChange(of: isPlaying) { _, newValue in
            if newValue {
                playerViewModel.play()
            } else {
                playerViewModel.pause()
            }
        }
    }
}


#Preview {
    VideoPlayerView(isPlaying: true, url: URL(string: "https://videos.pexels.com/video-files/30851527/13193570_1440_2560_25fps.mp4")!)
}
