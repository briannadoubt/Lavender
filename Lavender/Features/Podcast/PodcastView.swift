//
//  PodcastView.swift
//  Lavender
//
//  Created by Brianna Zamora on 3/22/24.
//

import SwiftUI
import SwiftData
import FeedKit
import Logs

extension RSSFeedItem: Identifiable {
    public var id: String {
        self.guid?.value ?? UUID().uuidString
    }
}

enum PodcastError: Error {
    case missingFeedURL
}

@Logging
struct SubscribeButton: View {
    @Environment(\.modelContext) var modelContext
    @Bindable var podcast: Podcast
    let feed: FeedKit.RSSFeed?
    @Query private var existingMatchingPodcasts: [Podcast]

    init(podcast: Podcast, feed: FeedKit.RSSFeed?) {
        _podcast = Bindable(podcast)
        self.feed = feed
        let collectionID = podcast.collectionID
        var fetchDescriptor = FetchDescriptor<Podcast>(predicate: #Predicate { $0.collectionID == collectionID }, sortBy: [SortDescriptor(\.releaseDate, order: .forward)])
        fetchDescriptor.fetchLimit = 1
        _existingMatchingPodcasts = Query(fetchDescriptor)
    }

    var body: some View {
        if existingMatchingPodcasts.isEmpty {
            Button("Add to Library", systemImage: "plus") {
                do {
                    podcast.latestEpisode = Item(feed?.items?.first)
                    modelContext.insert(podcast)
                    try modelContext.save()
                } catch {
                    Self.logger.error("Failed to insert podcast from library with error: \(error)")
                }
            }
        } else {
            Button("Remove from Library", systemImage: "minus.circle") {
                do {
                    modelContext.delete(podcast)
                    try modelContext.save()
                } catch {
                    Self.logger.error("Failed to remove podcast from library with error: \(error)")
                }
            }
        }
    }
}

@Logging
struct PodcastView: View {
    @Environment(\.modelContext) var modelContext
    @Bindable var podcast: Podcast

    @State private var feed: FeedKit.RSSFeed?

    var body: some View {
        List {
            PodcastImage(podcast: podcast)
                .frame(width: 300, height: 300)
            if let feed {
                ForEach(feed.items ?? []) { item in
                    ItemRow(podcast: podcast, item: Item(item))
                }
            } else {
                ProgressView("Loading feed...")
            }
        }
        .listStyle(.plain)
        .navigationTitle(podcast.collectionName ?? "Podcast")
        .toolbar {
            ToolbarItem(placement: .automatic) {
                SubscribeButton(podcast: podcast, feed: feed)
            }
        }
        .task {
            do {
                guard let feedURL = podcast.feedURL else {
                    throw PodcastError.missingFeedURL
                }
                let feedRequest = FeedParser(URL: feedURL)
                try await withCheckedThrowingContinuation { continuation in
                    feedRequest.parseAsync { result in
                        switch result {
                        case .success(let success):
                            switch success {
                            case .atom(_):
                                fatalError()
                            case .json(_):
                                fatalError()
                            case .rss(let feed):
                                self.feed = feed
                                continuation.resume()
                            }
                        case .failure(let failure):
                            continuation.resume(throwing: failure)
                        }
                    }
                }
            } catch {
                Self.logger.error("Failed to load feed with error: \(error)")
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
