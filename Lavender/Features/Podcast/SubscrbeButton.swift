//
//  SubscrbeButton.swift
//  Lavender
//
//  Created by Brianna Zamora on 4/5/24.
//

import SwiftUI
import FeedKit
import SwiftData

struct SubscribeButton: View, HasLogger {
    @Environment(\.modelContext) var modelContext
    @Bindable var podcast: Podcast

    @Query private var existingMatchingPodcasts: [Podcast]

    init(podcast: Podcast) {
        _podcast = Bindable(podcast)
        let collectionID = podcast.collectionID
        var fetchDescriptor = FetchDescriptor<Podcast>(predicate: #Predicate { $0.collectionID == collectionID }, sortBy: [SortDescriptor(\.releaseDate, order: .forward)])
        fetchDescriptor.fetchLimit = 1
        _existingMatchingPodcasts = Query(fetchDescriptor)
    }

    var body: some View {
        if existingMatchingPodcasts.isEmpty {
            Button("Add to Library", systemImage: "plus") {
                do {
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

#Preview {
    SubscribeButton(podcast: Podcast(collectionID: .init(-1)))
}
