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
    @Bindable var player: Player

    var body: some View {
        Group {
            LavenderTabView()
        }
        .environment(player)
#if os(visionOS)
        .ornament(attachmentAnchor: .scene(.bottom)) {
            PlayerOrnament()
                .environment(player)
        }
#else
        .overlay(alignment: .bottom) {
            if player.isPresented {
                PlayerOrnament()
                    .environment(player)
                    .padding()
                    .padding(.bottom, 44)
            }
        }
        .inspector(isPresented: $player.isFullScreen) {
            PlayerView()
                .environment(player)
                .presentationDetents([.large])
        }
#endif
    }
}

//#Preview {
//    ContentView()
//        .modelContainer(for: Podcast.self, inMemory: true)
//}
