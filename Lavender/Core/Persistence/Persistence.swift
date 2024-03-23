//
//  Persistence.swift
//  Lavender
//
//  Created by Brianna Zamora on 3/22/24.
//

import SwiftData

struct Persistence {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Podcast.self,
            RSSFeed.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
}
