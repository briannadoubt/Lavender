//
//  LavenderApp.swift
//  Lavender
//
//  Created by Brianna Zamora on 3/20/24.
//

import SwiftUI
import SwiftData
import Logs
import Dependencies
import UIKit
import AVKit
import MediaPlayer

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

@Logging
@objc
final class AppDelegate: NSObject, UIApplicationDelegate {

    static var shared: AppDelegate!

    let player: AVQueuePlayer
    let session: MPNowPlayingSession

    override init() {
        player = AVQueuePlayer()
        session = MPNowPlayingSession(players: [player])
        super.init()
    }
}

@Logging
@main
struct LavenderApp: App {
    private var persistence = Persistence()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    init() {
        AppDelegate.shared = delegate
    }

    @State private var player: Player?

    var body: some Scene {
        WindowGroup {
            if let player {
                ContentView(player: player)
                    .task {
                        let stream = player.player.isPlaying()
                        for await isPlaying in stream {

                        }
                    }
            } else {
                ProgressView("Loading player...")
                    .task {
                        var fetch = FetchDescriptor<Player>()
                        fetch.fetchLimit = 1
                        do {
                            if let existingPlayer = try persistence.sharedModelContainer.mainContext.fetch(fetch).first {
                                self.player = existingPlayer
                            } else {
                                let player = Player()
                                let currentlyPlaying = CurrentlyPlaying()
                                player.currentlyPlaying = currentlyPlaying
                                persistence.sharedModelContainer.mainContext.insert(player)
                                self.player = player
                            }
                        } catch {
                            Self.logger.error("Failed to fetch for existing player with error: \(error)")
                        }
                    }
            }
        }
        .modelContainer(persistence.sharedModelContainer)
        .commands {
            SidebarCommands()
        }
    }
}

