//
//  UpNext.swift
//  Lavender
//
//  Created by Brianna Zamora on 3/22/24.
//

import SwiftUI
import SwiftData

struct UpNextSection: View {
    @Query(
        sort: \Podcast.releaseDate,
        order: .reverse
    ) private var upNext: [Podcast]

    var body: some View {
        TileSection(header: "Up Next") {
            UpNextView(podcasts: upNext)
        } content: {
            ForEach(upNext) { podcast in
                PodcastTile(podcast: podcast)
            }
        }
    }
}

struct UpNextView: View {
    var podcasts: [Podcast]
    var body: some View {
        List(podcasts) { podcast in
            PodcastRow(podcast: podcast)
        }
        .listStyle(.plain)
        .navigationTitle("Up Next")
    }
}

#Preview {
    Group {
        UpNextSection()
        UpNextView(podcasts: [])
    }
    .modelContainer(for: [Podcast.self, RSSFeed.self], inMemory: true)
}
