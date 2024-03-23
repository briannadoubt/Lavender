//
//  ItemView.swift
//  Lavender
//
//  Created by Brianna Zamora on 3/22/24.
//

import SwiftUI

struct ItemRow: View {
    @Bindable var podcast: Podcast
    var item: RSSFeed.Item
    var body: some View {
        NavigationLink(item.title ?? "No title") {
            ItemView(podcast: podcast, item: item)
        }
    }
}

struct ItemView: View {
    @Bindable var podcast: Podcast
    var item: RSSFeed.Item
    var body: some View {
        List {
            PodcastImage(podcast: podcast)
                .frame(width: 300, height: 300, alignment: .center)
            ItemDescriptionView(item: item)
        }
        .navigationTitle(item.title ?? "Episode")
        .listStyle(.plain)
    }
}

struct ItemDescriptionView: View {
    var item: RSSFeed.Item
    var body: some View {
        if let itemDescription = item.itemDescription {
            Section {
                FullWidthHTMLText(content: itemDescription)
            }
        }
    }
}
