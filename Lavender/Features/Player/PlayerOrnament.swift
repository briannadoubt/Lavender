//
//  PlayerOrnament.swift
//  Lavender
//
//  Created by Brianna Zamora on 3/27/24.
//

import SwiftUI
import Dependencies
import AVKit
import Logs
import MediaPlayer
import SwiftData

struct PlayerOrnament: View {
    @Environment(Player.self) var player

    @ViewBuilder
    var nowPlaying: some View {
        HStack {
            if let podcast = player.currentlyPlaying?.podcast {
                PodcastImage(podcast: podcast)
                    .frame(width: 44, height: 44)
            }
            if let title = player.currentlyPlaying?.feedItem?.title {
                Text(title)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .frame(maxWidth: 320)
            }
        }
    }

    var body: some View {
        HStack(spacing: 12) {
            #if os(visionOS)
            nowPlaying
                .padding()
            #else
            Button {
                player.isFullScreen = true
            } label: {
                nowPlaying
            }
            #endif

            #if os(visionOS)
            SeekBackwardButton()
            #endif
            
            PlayPauseButton()
            SeekForwardButton()
        }
        .playbackControlSize(width: 24, height: 24)
        .padding(.horizontal, 8)
        #if os(visionOS)
        .glassBackgroundEffect()
        #else
        .background(.bar)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .shadow(radius: 10)
        .transition(.move(edge: .bottom))
        #endif
        .padding(.bottom, -8)
        .animation(.default, value: player.state)
        .animation(.default, value: player.isPresented)
    }
}

#Preview {
    PlayerOrnament()
}
