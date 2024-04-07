//
//  PlayerOrnament.swift
//  Lavender
//
//  Created by Brianna Zamora on 3/27/24.
//

import SwiftUI

extension View {
    @ViewBuilder
    var playerOrnament: some View {
        modifier(PlayerOrnamentViewModifier())
    }
}

struct PlayerOrnamentViewModifier: ViewModifier {
    @Environment(Player.self) private var player

    func body(content: Content) -> some View {
        @Bindable var player = player

        content
#if os(visionOS)
            .ornament(attachmentAnchor: .scene(.bottom)) {
                PlayerOrnament()
                    .environment(self.player)
            }
#else
            .overlay(alignment: .bottom) {
                PlayerOrnament()
                    .environment(self.player)
                    .padding()
                    .padding(.bottom, 44)
            }
            .inspector(isPresented: $player.isFullScreen) {
                if let currentlyPlaying = player.currentlyPlaying {
                    PlayerView(currentlyPlaying: currentlyPlaying)
                        .environment(self.player)
                        .presentationDetents([.large])
                } else {
                    ContentUnavailableView("Nothing Playing", systemImage: "play.slash")
                }
            }
#endif
    }
}

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
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
                    .frame(maxWidth: 320)
            }
        }
    }

    var body: some View {
        VStack {
            HStack(spacing: 12) {
#if os(visionOS)
                VStack {
                    nowPlaying
                }
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
            .padding(.top, 8)
            .padding(.horizontal, 8)

            PlayerScrubber(
                isInteractive: {
#if os(visionOS)
                    true
#else
                    false
#endif
                }()
            )
        }
        .playbackControlSize(width: 24, height: 24)
#if os(visionOS)
        .glassBackgroundEffect()
#else
        .background(.bar)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .shadow(radius: 10)
        .transition(.move(edge: .bottom))
        .padding(.bottom, -8)
#endif
//        .animation(.default, value: player.state)
        .animation(.default, value: player.isPresented)
    }
}

#Preview {
    PlayerOrnament()
}
