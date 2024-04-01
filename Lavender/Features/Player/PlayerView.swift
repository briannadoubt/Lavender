//
//  PlayerView.swift
//  Lavender
//
//  Created by Brianna Zamora on 3/30/24.
//

import SwiftUI

struct PlayerView: View {
    @Environment(Player.self) var player

    var body: some View {
        NavigationStack {
            VStack {
                let podcast = player.currentlyPlaying?.podcast
                let title = player.currentlyPlaying?.feedItem?.title
                Spacer()
                if let podcast {
                    PodcastImage(podcast: podcast)
                        .scaledToFit()
                }
                Spacer()
                if let title {
                    Text(title)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                }
                Spacer()
                HStack {
                    Group {
                        SeekBackwardButton()
                        PlayPauseButton()
                        SeekForwardButton()
                    }
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(.accent)
                    .playbackControlSize(width: 44, height: 44)
                }
                Spacer()
            }
            .padding()
        }
        .toolbar(.hidden)
    }
}
