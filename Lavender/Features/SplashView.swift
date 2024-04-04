//
//  SplashView.swift
//  Lavender
//
//  Created by Brianna Zamora on 4/3/24.
//

import SwiftUI
import SwiftData

struct SplashView: View, HasLogger {
    @Environment(\.modelContext) private var modelContext
    var setPlayer: @MainActor (_ player: Player) -> ()
    var body: some View {
        ProgressView("Loading player...")
            .task {
                var fetch = FetchDescriptor<Player>()
                fetch.fetchLimit = 1
                do {
                    if let existingPlayer = try modelContext.fetch(fetch).first {
                        setPlayer(existingPlayer)
                    } else {
                        let player = Player()
                        let currentlyPlaying = CurrentlyPlaying()
                        player.currentlyPlaying = currentlyPlaying
                        modelContext.insert(player)
                        setPlayer(player)
                    }
                } catch {
                    Self.logger.error("Failed to fetch for existing player with error: \(error)")
                }
            }
    }
}
