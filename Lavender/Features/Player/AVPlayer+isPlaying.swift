//
//  AVPlayer+isPlaying.swift
//  Lavender
//
//  Created by Brianna Zamora on 4/3/24.
//

import Foundation
import AVKit
import SwiftUI

extension View {
    @ViewBuilder
    func onPlaybackChange(_ perform: @escaping (_ isPlaying: Bool) -> ()) -> some View {
        modifier(IsPlayingViewModifier(isPlaying: perform))
    }
}

struct IsPlayingViewModifier: ViewModifier {
    @ViewBuilder var isPlaying: (_ isPlaying: Bool) -> ()

    func body(content: Content) -> some View {
        content
            .task {
                let stream = AppDelegate.shared.queue.isPlaying()
                for await isPlaying in stream {
                    await MainActor.run {
                        self.isPlaying(isPlaying)
                    }
                }
            }
    }
}

extension AVPlayer {
    func isPlaying() -> AsyncStream<Bool> {
        AsyncStream { cont in
            let observation = self.observe(\.rate) { player, value in
                cont.yield(player.timeControlStatus == .playing)
            }
            cont.yield(timeControlStatus == .playing)
            cont.onTermination = { _ in
                observation.invalidate()
            }
        }
    }
}
