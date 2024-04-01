//
//  PlayerButtons.swift
//  Lavender
//
//  Created by Brianna Zamora on 3/28/24.
//

import SwiftUI

extension View {
    @ViewBuilder
    func playbackControlSize(
        width: CGFloat,
        height: CGFloat
    ) -> some View {
        environment(\.playbackControlSize, CGSize(width: width, height: height))
    }
}

struct PlaybackControlSize: EnvironmentKey {
    static var defaultValue: CGSize? { nil }
}

extension EnvironmentValues {
    var playbackControlSize: CGSize? {
        get { self[PlaybackControlSize.self] }
        set { self[PlaybackControlSize.self] = newValue }
    }
}

struct PlaybackControlButton: View {
    @Environment(\.playbackControlSize) private var size
    var systemImage: String
    var action: () -> ()
    var body: some View {
        Button {
            action()
        } label: {
            Image(systemName: systemImage)
                .resizable()
                .scaledToFit()
                .frame(width: size?.width, height: size?.height)
        }
    }
}

struct SeekBackwardButton: View {
    @Environment(Player.self) private var player
    @Environment(\.playbackControlSize) private var size
    var body: some View {
        PlaybackControlButton(systemImage: "gobackward.15") {
            player.seekBackword()
        }
    } 
}

struct ItemPlayPauseButton: View {
    @Environment(Player.self) private var player
    @Environment(\.playbackControlSize) private var size

    @Bindable var item: Item
    
    var willPlay: () -> () = {}

    @MainActor
    func play() {
        willPlay()

        guard
            let feedItem = player.currentlyPlaying?.feedItem,
            let podcast = player.currentlyPlaying?.podcast
        else {
            assertionFailure("No currently playing media set!")
            return
        }

        Task {
            await player.play(feedItem, podcast: podcast)
        }
    }

    var body: some View {
        let isPlayingItem = player.currentlyPlaying?.feedItem?.id == item.id && player.hasCurrentItem

        switch player.state {
        case .loading:
            ProgressView()
                .frame(width: size?.width, height: size?.height)
        case .paused:
                PlaybackControlButton(systemImage: "play.fill") {
                    if isPlayingItem {
                        player.resume()
                    } else {
                        play()
                    }
                }
        case .playing:
            PlaybackControlButton(systemImage: "pause.fill") {
                player.pause()
            }
        case .stopped, .ready:
            PlaybackControlButton(systemImage: "play.fill") {
                play()
            }
        }
    }
}

struct PlayPauseButton: View {
    @Environment(Player.self) private var player
    @Environment(\.playbackControlSize) private var size

    var willPlay: () -> () = {}

    var body: some View {
        switch player.state {
        case .loading:
            ProgressView()
                .frame(width: size?.width, height: size?.height)
        case .paused:
            PlaybackControlButton(systemImage: "play.fill") {
                player.resume()
            }
        case .playing:
            PlaybackControlButton(systemImage: "pause.fill") {
                player.pause()
            }
        case .stopped, .ready:
            PlaybackControlButton(systemImage: "play.fill") {
                willPlay()
                if
                    let feedItem = player.currentlyPlaying?.feedItem,
                    let podcast = player.currentlyPlaying?.podcast
                {
                    Task {
                        await player.play(feedItem, podcast: podcast)
                    }
                } else {
                    assertionFailure("No currently playing media set!")
                }
            }
        }
    }
}

struct SeekForwardButton: View {
    @Environment(Player.self) private var player
    @Environment(\.playbackControlSize) private var size
    var body: some View {
        Button {
            player.seekForward()
        } label: {
            Image(systemName: "goforward.30")
                .resizable()
                .scaledToFit()
                .frame(width: size?.width, height: size?.height)
        }
    }
}

struct PlayerButtons: View {
    var body: some View {
        SeekBackwardButton()
        PlayPauseButton()
        SeekForwardButton()
    }
}

#Preview {
    PlayerButtons()
}
