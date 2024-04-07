//
//  PlayerButtons.swift
//  Lavender
//
//  Created by Brianna Zamora on 3/28/24.
//

import SwiftUI
import CoreMedia

struct PlayerScrubber: View, @unchecked Sendable {
    @Environment(Player.self) var player

    var isInteractive = true

    @State var observer: Any?

    @MainActor
    func set(playPosition: Double) {
        self.player.currentlyPlaying?.playPosition = playPosition
    }

    @MainActor
    func observePlaybackState() async {
        for await isPlaying in AppDelegate.shared.queue.isPlaying() {
            if isPlaying {
                observer = AppDelegate.shared.queue.addPeriodicTimeObserver(forInterval: CMTime(seconds: 0.5, preferredTimescale: 600), queue: nil) { time in
                    MainActor.assertIsolated()
                    MainActor.assumeIsolated {
                        guard let item = AppDelegate.shared.queue.currentItem else {
                            return
                        }
                        self.set(playPosition: time.seconds / item.duration.seconds)
                    }
                }
            } else {
                if let observer {
                    AppDelegate.shared.queue.removeTimeObserver(observer)
                }
                observer = nil
            }
        }
    }

    var body: some View {
        @Bindable var player = player
        let playPosition = Binding(get: {
            player.currentlyPlaying?.playPosition ?? 0
        }, set: { newPlayPosition in
            player.currentlyPlaying?.playPosition = newPlayPosition
        })
        HStack {
            if isInteractive {
                Slider(value: playPosition, in: 0...1) {
                    Text("Meow")
                } minimumValueLabel: {
                    Text("\(player.currentlyPlaying?.playPosition.hms ?? "~:~")")
                } maximumValueLabel: {
                    Text("\(player.currentlyPlaying?.duration.hms ?? "~:~")")
                } onEditingChanged: { _ in
                    guard let item = self.player.queue.currentItem else {
                        return
                    }
                    let targetTime = playPosition.wrappedValue * item.duration.seconds
                    self.player.queue.seek(to: CMTime(seconds: targetTime, preferredTimescale: 600))
                }
                .padding(.horizontal)
            } else {
                ProgressView(value: player.currentlyPlaying?.playPosition ?? 0, total: 1)
                    .ignoresSafeArea()
            }
        }
        .task {
            await observePlaybackState()
        }
    }
}

extension Double {
    var hms: String {
        let timeHMSFormatter: DateComponentsFormatter = {
            let formatter = DateComponentsFormatter()
            formatter.unitsStyle = .positional
            formatter.allowedUnits = [.minute, .second]
            formatter.zeroFormattingBehavior = [.pad]
            return formatter
        }()
        guard
            !isNaN,
            let text = timeHMSFormatter.string(from: self) else {
            return "00:00"
        }
        return text
    }
}

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
