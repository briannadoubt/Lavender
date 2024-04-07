//
//  Player.swift
//  Lavender
//
//  Created by Brianna Zamora on 3/28/24.
//

@preconcurrency import Foundation
import SwiftData
import Dependencies
import AVKit
import SwiftUI
@preconcurrency import MediaPlayer
import FeedKit

@Model
class Player: HasLogger {
    var currentlyPlaying: CurrentlyPlaying?

    var state: PlayerState = PlayerState.ready

    var isFullScreen = false

    private(set) var duration: TimeInterval = 0.0
    private(set) var currentTime: TimeInterval = 0.0

    init() {}
}

extension Player {
    var isPresented: Bool {
        !isFullScreen
    }

    @MainActor
    var hasCurrentItem: Bool {
        queue.currentItem != nil
    }

    @MainActor
    var session: MPNowPlayingSession {
        AppDelegate.shared.session
    }

    @MainActor
    var queue: AVQueuePlayer {
        AppDelegate.shared.queue
    }

    @MainActor
    func activateSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .spokenAudio, policy: .longFormAudio)
            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
#if os(visionOS)
            try AVAudioSession.sharedInstance().setIsNowPlayingCandidate(true)
            try AVAudioSession.sharedInstance().setIntendedSpatialExperience(.fixed(soundStageSize: .automatic))
#endif
        } catch {
            Self.logger.error("Failed to set up AVAudioSession.sharedInstance() with error: \(error)")
            assertionFailure("Failed to set up AVAudioSession.sharedInstance() with error: \(error)")
        }
    }

    @MainActor
    func setNowPlaying(_ feedItem: Item, podcast: Podcast) async {
        if currentlyPlaying == nil {
            currentlyPlaying = CurrentlyPlaying()
        }

        currentlyPlaying?.feedItem = feedItem
        currentlyPlaying?.podcast = podcast
    }

    @MainActor
    func configureSession() async {
        guard await session.becomeActiveIfPossible() else {
            Self.logger.error("Failed to activate AVAudioSession")
            return
        }
        session.automaticallyPublishesNowPlayingInfo = true
        session.remoteCommandCenter.skipForwardCommand.preferredIntervals = [30.0]
        session.remoteCommandCenter.skipForwardCommand.addTarget { event in
            MainActor.assumeIsolated {
                self.seekForward()
                return .success
            }
        }

        session.remoteCommandCenter.skipBackwardCommand.preferredIntervals = [15.0]
        session.remoteCommandCenter.skipBackwardCommand.addTarget { event in
            MainActor.assumeIsolated {
                self.seekBackword()
                return .success
            }
        }

        session.remoteCommandCenter.playCommand.addTarget { event in
            MainActor.assumeIsolated {
                if
                    let item = self.currentlyPlaying?.feedItem,
                    let podcast = self.currentlyPlaying?.podcast
                {
                    Task {
                        await self.play(item, podcast: podcast)
                    }
                    return .success
                } else {
                    self.resume()
                    return .success
                }
            }
        }

        session.remoteCommandCenter.pauseCommand.addTarget { event in
            MainActor.assumeIsolated {
                self.pause()
                return .success
            }
        }

        session.remoteCommandCenter.togglePlayPauseCommand.addTarget { event in
            MainActor.assumeIsolated {
                if self.state == .playing {
                    self.pause()
                } else {
                    self.resume()
                }
                return .success
            }
        }
    }

    @MainActor
    private func getArtwork(from url: URL) async -> MPMediaItemArtwork {
        let image = await getCurrentlyPlayingImage(url: url)
        let artwork = MPMediaItemArtwork(boundsSize: CGSize(width: 600, height: 600)) { _ in
            image ?? UIImage(named: "placeholder")!
        }
        return artwork
    }

    @MainActor
    func configurePlayer(_ feedItem: Item, podcast: Podcast) async {
        guard let audioURL = feedItem.enclosure?.url else {
            Self.logger.error("RSSFeed.Enclosure.url is nil")
            return
        }

        guard let imageURL = podcast.artworkUrl600 else {
            Self.logger.error("No image URL found")
            return
        }

        let artwork = await getArtwork(from: imageURL)

        queue.audiovisualBackgroundPlaybackPolicy = .continuesIfPossible

        queue.replaceCurrentItem(
            with: {
                let playerItem = AVPlayerItem(url: audioURL)
                playerItem.nowPlayingInfo = [
                    MPMediaItemPropertyAssetURL: audioURL,
                    MPMediaItemPropertyArtist: podcast.collectionName ?? "Podcast",
                    MPMediaItemPropertyPodcastPersistentID: podcast.collectionID ?? 0,
                    MPMediaItemPropertyTitle: feedItem.title ?? "Lavender",
                    MPMediaItemPropertyArtwork: artwork
                ]
                return playerItem
            }()
        )

//        timeObserver = player.addPeriodicTimeObserver(
//            forInterval: CMTime(
//                value: 1,
//                timescale: 2
//            ),
//            queue: .main,
//            using: { [weak self] time in
//                MainActor.assumeIsolated {
//                    guard let self else { return }
//                    // Update the published currentTime and duration values.
//                    self.currentTime = time.seconds
//                    self.duration = self.player.currentItem?.duration.seconds ?? 0.0
//                }
//            }
//        )
    }

    @MainActor
    func play(_ feedItem: Item, podcast: Podcast) async {
        await configureSession()
        activateSession()
        await setNowPlaying(feedItem, podcast: podcast)
        await configurePlayer(feedItem, podcast: podcast)

        queue.play()
        self.state = .playing
    }

    @MainActor
    func getCurrentlyPlayingImage(url: URL) async -> UIImage? {
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let image = UIImage(data: data) else {
                Self.logger.error("Downloaded data was not an image")
                return nil
            }
            return image
        } catch {
            Self.logger.error("Failed to download image with error: \(error)")
            return nil
        }
    }

    @MainActor
    func pause() {
        queue.pause()
        try? AVAudioSession.sharedInstance().setActive(false)
        self.state = .paused
    }

    @MainActor
    func resume() {
        queue.play()
        try? AVAudioSession.sharedInstance().setActive(true)
        self.state = .playing
    }

    @MainActor
    func seekBackword() {
        queue.seek(to: CMTimeSubtract(queue.currentTime(), CMTimeMakeWithSeconds(15, preferredTimescale: 1)))
    }

    @MainActor
    func seekForward() {
        queue.seek(to: CMTimeAdd(queue.currentTime(), CMTimeMakeWithSeconds(30, preferredTimescale: 1)))
    }
}

enum PlayerState: Codable, Sendable {
    case loading
    case ready
    case paused
    case playing
    case stopped
}
