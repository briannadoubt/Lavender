//
//  ContentView.swift
//  Lavender
//
//  Created by Brianna Zamora on 3/20/24.
//

import SwiftUI
import SwiftData
import NavigationGroup

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Bindable var player: Player

    var body: some View {
        NavigationGroup("Lavender", for: LavenderScreen.self) { screen in
            switch screen {
            case .home:
                HomeView()
            case .search:
                PodcastSearch()
            }
        }
        .playerOrnament
        .environment(player)
    }
}

//#Preview {
//    ContentView(player: Player())
//        .modelContainer(
//            for: [
//                Podcast.self,
//                RSSFeed.self,
//                Item.self
//            ],
//            inMemory: true
//        )
//}
