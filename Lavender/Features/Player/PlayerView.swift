//
//  PlayerView.swift
//  Lavender
//
//  Created by Brianna Zamora on 3/30/24.
//

import SwiftUI

struct PlayerView: View {
    @Bindable var currentlyPlaying: CurrentlyPlaying

    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                if let podcast = currentlyPlaying.podcast {
                    PodcastImage(podcast: podcast)
                        .scaledToFit()
                }
                Spacer()
                if let title = currentlyPlaying.feedItem?.title {
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
