//
//  PodcastView.swift
//  Lavender
//
//  Created by Brianna Zamora on 3/22/24.
//

import SwiftUI
import SwiftData

struct PodcastView: View {
    @Environment(\.modelContext) var modelContext
    @Bindable var podcast: Podcast

    @Query var feed: [RSSFeed]

    init(podcast: Podcast) {
        let podcastID = podcast.collectionID
        var fetch = FetchDescriptor<RSSFeed>(predicate: #Predicate { $0.podcast?.collectionID == podcastID })
        fetch.fetchLimit = 1
        _feed = Query(fetch)
        self.podcast = podcast
    }

    var body: some View {
        List {
            PodcastImage(podcast: podcast)
                .frame(width: 300, height: 300)
            if let feed = feed.first {
                ForEach(feed.items ?? []) { item in
                    ItemRow(podcast: podcast, item: item)
                }
            } else {
                ProgressView("Loading feed...")
            }
        }
        .listStyle(.plain)
        .navigationTitle(podcast.collectionName ?? "Podcast")
        .task {
            let container = modelContext.container
            Task.detached {
                let lavendar = Lavendar(modelContainer: container)
                do {
                    try await lavendar.loadFeed(for: podcast)
                } catch {
                    print("Failed to load feed with error:", error)
                }
            }
        }
    }
}

struct PodcastRow: View {
    @Bindable var podcast: Podcast

    var body: some View {
        NavigationLink {
            PodcastView(podcast: podcast)
        } label: {
            HStack(alignment: .top) {
                PodcastImage(podcast: podcast)
                    .frame(width: 100, height: 100)
                VStack(alignment: .leading) {
                    if let collectionName = podcast.collectionName {
                        Text(collectionName)
                            .bold()
                    }
                    if let artistName = podcast.artistName {
                        Text(artistName)
                    }
                }
            }
        }
    }
}

struct PodcastImage: View {
    @Bindable var podcast: Podcast
    var body: some View {
        AsyncImage(url: podcast.artworkUrl600) { result in
            if let image = result.image {
                image
                    .resizable()
                    .scaledToFill()
            }
        }
    }
}

struct PodcastLink: View {
    @Bindable var podcast: Podcast

    var body: some View {
        NavigationLink {
            PodcastView(podcast: podcast)
        } label: {
            VStack(alignment: .leading) {
                PodcastImage(podcast: podcast)
                    .frame(width: 300, height: 300)

                if let collectionName = podcast.collectionName {
                    Text(collectionName)
                        .bold()
                }

                if let artistName = podcast.artistName {
                    Text(artistName)
                }
            }
        }
    }
}

struct PodcastTile: View {
    @Bindable var podcast: Podcast

    var body: some View {
        NavigationLink {
            PodcastView(podcast: podcast)
        } label: {
            VStack(alignment: .leading) {
                PodcastImage(podcast: podcast)
                    .frame(width: 300, height: 300)

                if let collectionName = podcast.collectionName {
                    Text(collectionName)
                        .bold()
                }

                if let artistName = podcast.artistName {
                    Text(artistName)
                }
            }
        }
    }
}

//#Preview {
//    PodcastView()
//}
