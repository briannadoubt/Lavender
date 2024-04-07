//
//  PodcastView.swift
//  Lavender
//
//  Created by Brianna Zamora on 3/22/24.
//

import SwiftUI
import SwiftData
import FeedKit

extension RSSFeedItem: Identifiable {
    public var id: String {
        self.guid?.value ?? UUID().uuidString
    }
}

enum PodcastError: Error {
    case missingFeedURL
}

struct PodcastView: View, HasLogger {
    @Environment(\.modelContext) var modelContext
    @Bindable var podcast: Podcast

    @State private var feed: FeedKit.RSSFeed?

    @MainActor
    func load() async {
        do {
            guard let feedURL = try podcast.feedURL?.withSecureHost else {
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

#if DEBUG
    @State var isPresentingDebug = false
#endif

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
            SubscribeButton(podcast: podcast)

#if DEBUG
            Button("Debug", systemImage: "ladybug.circle") {
                isPresentingDebug = true
            }
#endif
        }
        .task {
            await load()
        }
        .refreshable {
            await load()
        }
#if DEBUG
        .sheet(isPresented: $isPresentingDebug, content: {
            NavigationStack {
                List {
                    debugRow("collectionName", value: podcast.collectionName)
                    debugRow("collectionID", value: String(describing: podcast.collectionID))
                    debugRow("artistName", value: podcast.artistName)
                    debugRow("feedURL", value: podcast.feedURL?.absoluteString)
                    debugRow("releaseDate", value: podcast.releaseDate?.formatted())
                    debugRow("artistID", value: String(describing: podcast.artistID))
                    debugRow("artistViewURL", value: podcast.artistViewURL?.absoluteString)
                    debugRow("artworkUrl600", value: podcast.artworkUrl600?.absoluteString)
                    debugRow("artworkUrl100", value: podcast.artworkUrl100?.absoluteString)
                    debugRow("artworkUrl30", value: podcast.artworkUrl30?.absoluteString)
                    debugRow("artworkUrl60", value: podcast.artworkUrl60?.absoluteString)
                    debugRow("collectionCensoredName", value: podcast.collectionCensoredName)
                    debugRow("collectionExplicitness", value: podcast.collectionExplicitness)
                    debugRow("contentAdvisoryRating", value: podcast.contentAdvisoryRating)
                    debugRow("collectionHDPrice", value: String(describing: podcast.collectionHDPrice))
                    debugRow("collectionPrice", value: String(describing: podcast.collectionPrice))
                    debugRow("inLibrary", value: String(describing: podcast.inLibrary))
                    debugRow("collectionViewURL", value: podcast.collectionViewURL?.absoluteString)
                    debugRow("country", value: podcast.country)
                    debugRow("currency", value: podcast.currency)
                    debugRow("kind", value: podcast.kind)
                    debugRow("primaryGenreName", value: podcast.primaryGenreName)
                    debugRow("trackCensoredName", value: podcast.trackCensoredName)
                    debugRow("trackExplicitness", value: podcast.trackExplicitness)
                    debugRow("trackName", value: podcast.trackName)
                    debugRow("genreIDs", value: podcast.genreIDS?.joined(separator: ", "))
                    debugRow("genres", value: podcast.genres?.joined(separator: ", "))
                    debugRow("primaryGenreName", value: podcast.primaryGenreName)
                    debugRow("trackCount", value: String(describing: podcast.trackCount))
                    debugRow("trackID", value: String(describing: podcast.trackID))
                    debugRow("trackPrice", value: String(describing: podcast.trackPrice))
                    debugRow("trackTimeMillis", value: String(describing: podcast.trackTimeMillis))
                    debugRow("trackViewURL", value: podcast.trackViewURL?.absoluteString)
                    debugRow("wrapperType", value: podcast.wrapperType?.rawValue)
                }
            }
        })
#endif
    }
#if DEBUG
    @ViewBuilder
    func debugRow(_ label: String, value: String?) -> some View {
        HStack {
            Text(label + ":")
                .bold()
            Text(value ?? "No value")
        }
    }
#endif
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
