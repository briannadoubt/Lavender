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
#if DEBUG
    @State private var isPresentingDebug = false
#endif
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
        .toolbar {
#if DEBUG
            Button("Debug", systemImage: "ladybug.circle") {
                isPresentingDebug = true
            }
#endif
        }
#if DEBUG
        .sheet(isPresented: $isPresentingDebug) {
            List {
                debugRow("title", value: item.title)
                debugRow("description", value: item.itemDescription)
                debugRow("author", value: item.author)
                debugRow("comments", value: item.comments)
                debugRow("link", value: item.link)
                debugRow("pubDate", value: item.pubDate?.formatted())
                
                DisclosureGroup("Enclosure") {
                    debugRow("length", value: String(describing: item.enclosure?.length))
                    debugRow("type", value: item.enclosure?.type)
                    debugRow("url", value: item.enclosure?.url?.absoluteString)
                }

                DisclosureGroup("Content") {
                    debugRow("contentEncoded", value: item.content?.contentEncoded)
                }

                DisclosureGroup("Dublin Core") {
                    debugRow("dcCoverage", value: item.dublinCore?.dcCoverage)
                    debugRow("dcCreator", value: item.dublinCore?.dcCreator)
                    debugRow("dcDescription", value: item.dublinCore?.dcDescription)
                    debugRow("dcFormat", value: item.dublinCore?.dcFormat)
                    debugRow("dcIdentifier", value: item.dublinCore?.dcIdentifier)
                    debugRow("dcLanguage", value: item.dublinCore?.dcLanguage)
                    debugRow("dcPublisher", value: item.dublinCore?.dcPublisher)
                    debugRow("dcRelation", value: item.dublinCore?.dcRelation)
                    debugRow("dcRights", value: item.dublinCore?.dcRights)
                    debugRow("dcSource", value: item.dublinCore?.dcSource)
                    debugRow("dcSubject", value: item.dublinCore?.dcSubject)
                    debugRow("dcTitle", value: item.dublinCore?.dcTitle)
                    debugRow("dcType", value: item.dublinCore?.dcType)
                    debugRow("dcDate", value: item.dublinCore?.dcDate?.formatted())
                }

                DisclosureGroup("GUID") {
                    debugRow("isPermalink", value: String(describing: item.guid?.isPermaLink))
                    debugRow("value", value: item.guid?.value)
                }

                DisclosureGroup("iTunes") {
                    debugRow("iTunesBlock", value: item.itunes?.iTunesBlock)
                    debugRow("iTunesComplete", value: item.itunes?.iTunesComplete)
                    debugRow("iTunesEpisodeType", value: item.itunes?.iTunesEpisodeType)
                    debugRow("iTunesAuthor", value: item.itunes?.iTunesAuthor)
                    debugRow("iTunesDuration", value: String(describing: item.itunes?.iTunesDuration))
                    debugRow("iTunesExplicit", value: item.itunes?.iTunesExplicit)
                    debugRow("iTunesEpisode", value: String(describing: item.itunes?.iTunesEpisode))
                    debugRow("iTunesKeywords", value: item.itunes?.iTunesKeywords)
                    debugRow("iTunesNewFeedURL", value: item.itunes?.iTunesNewFeedURL)
                    debugRow("iTunesOrder", value: String(describing: item.itunes?.iTunesOrder))
                    debugRow("isClosedCaptioned", value: item.itunes?.isClosedCaptioned)
                    debugRow("iTunesSeason", value: String(describing: item.itunes?.iTunesSeason))
                    debugRow("iTunesSubtitle", value: item.itunes?.iTunesSubtitle)
                    debugRow("iTunesSummary", value: item.itunes?.iTunesSummary)
                    debugRow("iTunesTitle", value: item.itunes?.iTunesTitle)
                    debugRow("iTunesType", value: item.itunes?.iTunesType)

                    DisclosureGroup("Categories") {
                        ForEach(item.itunes?.iTunesCategories ?? []) { category in
                            debugRow("text", value: category.text)
                            debugRow("subcategory.text", value: category.subcategory?.text)
                        }
                    }

                    DisclosureGroup("Image") {
                        debugRow("href", value: item.itunes?.iTunesImage?.href)
                    }

                    DisclosureGroup("Owner") {
                        debugRow("email", value: item.itunes?.iTunesOwner?.email)
                        debugRow("name", value: item.itunes?.iTunesOwner?.name)
                    }
                }

                DisclosureGroup("Media") {
                    debugRow("mediaBackLinks", value: item.media?.mediaBackLinks?.joined(separator: ", "))
                    DisclosureGroup("Category") {
                        debugRow("label", value: item.media?.mediaCategory?.label)
                        debugRow("scheme", value: item.media?.mediaCategory?.scheme)
                        debugRow("value", value: item.media?.mediaCategory?.value)
                    }
                    debugRow("mediaComments", value: item.media?.mediaComments?.joined(separator: ", "))
                    DisclosureGroup("Community") {
                        DisclosureGroup("Star rating") {
                            debugRow("Average", value: String(describing: item.media?.mediaCommunity?.mediaStarRating?.average))
                            debugRow("count", value: String(describing: item.media?.mediaCommunity?.mediaStarRating?.count))
                            debugRow("max", value: String(describing: item.media?.mediaCommunity?.mediaStarRating?.max))
                            debugRow("min", value: String(describing: item.media?.mediaCommunity?.mediaStarRating?.min))
                        }
                        DisclosureGroup("Statistics") {
                            debugRow("favorites", value: String(describing: item.media?.mediaCommunity?.mediaStatistics?.favorites))
                            debugRow("views", value: String(describing: item.media?.mediaCommunity?.mediaStatistics?.views))
                        }
                        DisclosureGroup("Tags") {
                            ForEach(item.media?.mediaCommunity?.mediaTags ?? []) { tag in
                                debugRow(tag.tag ?? "Unknown tag", value: String(describing: tag.weight))
                            }
                        }
                    }
                    DisclosureGroup("Contents") {
                        ForEach(item.media?.mediaContents ?? []) { content in
                            DisclosureGroup(content.mediaTitle ?? "Missing title")
                            debugRow("description", value: content.mediaDescription)
                            DisclosureGroup("Player") {
                                debugRow("url", value: content.player?.url)
                                debugRow("width", value: String(describing: content.player?.width))
                                debugRow("height", value: String(describing: content.player?.height))
                                debugRow("value", value: content.player?.value)
                            }
                            DisclosureGroup("Thumbnails") {
                                ForEach(content.mediaThumbnails) { thumbnail in
                                    DisclosureGroup(thumbnail.value ?? "") {
                                        debugRow("url", value: thumbnail.url)
                                        debugRow("width", value: thumbnail.width)
                                        debugRow("height", value: thumbnail.height)
                                        debugRow("time", value: thumbnail.time)
                                        debugRow("value", value: thumbnail.value)
                                    }
                                }
                            }
                            debugRow("keywords", value: content.mediaKeywords?.joined(separator: ", "))
                            DisclosureGroup("Category") {
                                debugRow("scheme", value: content.category?.scheme)
                                debugRow("label", value: content.category?.label))
                                debugRow("keywords", value: content.mediaCategory?.)
                            }
                        }
                    }
                }
            }
        }
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
