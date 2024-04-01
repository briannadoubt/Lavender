//
//  ItemView.swift
//  Lavender
//
//  Created by Brianna Zamora on 3/22/24.
//

import SwiftUI
import FeedKit

struct ItemRow: View {
    @Bindable var podcast: Podcast
    @Bindable var item: Item
    var body: some View {
        NavigationLink(item.title ?? "No title") {
            ItemView(podcast: podcast, item: item)
        }
    }
}

struct ItemView: View {
    @Bindable var podcast: Podcast
    @Bindable var item: Item
    @Environment(Player.self) var player
    var body: some View {
        List {
            HStack {
                PodcastImage(podcast: podcast)
                    .frame(width: 300, height: 300, alignment: .center)
                ItemPlayPauseButton(item: item) {
                    player.currentlyPlaying?.feedItem = item
                    player.currentlyPlaying?.podcast = podcast
                }
                .playbackControlSize(width: 44, height: 44)
            }
            ItemDescriptionView(item: item)
        }
        .navigationTitle(item.title ?? "Episode")
        .listStyle(.plain)
    }
}

struct ItemDescriptionView: View {
    @Bindable var item: Item
    var body: some View {
        if let itemDescription = item.itemDescription {
            Section {
                FullWidthHTMLText(content: itemDescription)
            }
        }
    }
}
