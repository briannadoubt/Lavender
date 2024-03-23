//
//  ContentView.swift
//  Lavender
//
//  Created by Brianna Zamora on 3/20/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        AppTabView()
            .task {
                let container = modelContext.container
                Task.detached {
                    let brain = Lavendar(modelContainer: container)
                    await brain.syncPodcasts()
                }
            }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Podcast.self, inMemory: true)
}
