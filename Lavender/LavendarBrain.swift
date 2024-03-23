//
//  LavendarBrain.swift
//  Lavender
//
//  Created by Brianna Zamora on 3/21/24.
//

import Foundation
import SwiftData
import FeedKit
import BackgroundTasks

@ModelActor
actor Lavendar {
    let itunes = iTunesAPI()
    func search(_ term: String) async throws {
        let result = try await itunes.search(term: term)
        try modelContext.transaction {
            let podcasts = result.results.map { Podcast($0) }
            try store(podcasts: podcasts)
        }
    }

    func lookup(podcast: Podcast) async throws -> Podcast.SearchResult? {
        try await itunes.lookupPodcast(collectionID: podcast.collectionID).results.first
    }

    func syncPodcasts() async {
        do {
            let podcasts: [Podcast] = try modelContext.fetch(FetchDescriptor<Podcast>())
            for podcast in podcasts {
                do {
                    if let result = try await lookup(podcast: podcast) {
                        try store(podcasts: [Podcast(result)])
                    }
                } catch {
                    continue
                }
            }
        } catch {
            print("Failed to sync podcasts with error:", error)
        }
    }

    func store(podcasts: [Podcast]) throws {
        // Remove existing/matching podcasts
        let collectionIDs = podcasts.map(\.collectionID)
        let descriptor: FetchDescriptor<Podcast> = FetchDescriptor(
            predicate: #Predicate<Podcast> { collectionIDs.contains($0.collectionID) },
            sortBy: [SortDescriptor(\Podcast.releaseDate)]
        )
        let matchingPodcasts: [Podcast] = try modelContext.fetch(descriptor)
        for existingPodcast in matchingPodcasts {
            modelContext.delete(existingPodcast)
        }
        // Store the new podcasts
        for podcast in podcasts {
            modelContext.insert(podcast)
        }
    }

    func loadFeed(for podcast: Podcast) async throws {
        guard let feedURL = podcast.feedURL else {
            throw PodcastActorError.missingFeedURL
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
                        let newFeed = RSSFeed(feed)
                        newFeed.podcast = podcast
                        self.modelContext.insert(newFeed)
                        continuation.resume()
                    }
                case .failure(let failure):
                    continuation.resume(throwing: failure)
                }
            }
        }
    }
}

enum PodcastActorError: Error {
    case failedToAddPercentEncodingToTerm
    case missingFeedURL
}
