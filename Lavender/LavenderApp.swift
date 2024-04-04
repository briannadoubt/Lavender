//
//  LavenderApp.swift
//  Lavender
//
//  Created by Brianna Zamora on 3/20/24.
//

import SwiftUI
import SwiftData

@main
struct LavenderApp: App, HasLogger {
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
                    .onPlaybackChange { isPlaying in
                        player.currentlyPlaying?.isPlaying = isPlaying
                    }
            } else {
                SplashView { player in
                    self.player = player
                }
            }
        }
        .modelContainer(persistence.sharedModelContainer)
        .commands {
            SidebarCommands()
        }
    }
}

