//
//  Persistence.swift
//  Lavender
//
//  Created by Brianna Zamora on 3/22/24.
//

import SwiftData

struct Persistence: HasLogger {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Podcast.self,
            RSSFeed.self,
            Player.self,
            CurrentlyPlaying.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            Self.logger.error("Could not create ModelContainer: \(error)")
            return try! ModelContainer(for: Schema([]), configurations: [modelConfiguration])
        }
    }()
}
