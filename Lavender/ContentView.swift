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

    @SceneStorage("com.briannadoubt.lavender.currentScreen") var currentScreen: LavenderScreen = .home

    var body: some View {
        NavigationGroup("Lavender", currentScreen: $currentScreen) { screen in
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
//    ContentView()
//        .modelContainer(for: Podcast.self, inMemory: true)
//}
