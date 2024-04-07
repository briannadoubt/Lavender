//
//  Podcast.swift
//  Lavender
//
//  Created by Brianna Zamora on 3/20/24.
//

import Foundation
import SwiftData

@Model
final class Podcast {
    init(_ result: SearchResult) {
        wrapperType = result.wrapperType
        kind = result.kind
        artistID = result.artistID
        collectionID = result.collectionID
        trackID = result.trackID
        artistName = result.artistName
        collectionName = result.collectionName
        trackName = result.trackName
        collectionCensoredName = result.collectionCensoredName
        trackCensoredName = result.trackCensoredName
        artistViewURL = result.artistViewURL
        collectionViewURL = result.collectionViewURL
        feedURL = result.feedURL
        trackViewURL = result.trackViewURL
        artworkUrl30 = result.artworkUrl30
        artworkUrl60 = result.artworkUrl60
        artworkUrl100 = result.artworkUrl100
        collectionPrice = result.collectionPrice
        trackPrice = result.trackPrice
        collectionHDPrice = result.collectionHDPrice
        releaseDate = result.releaseDate
        collectionExplicitness = result.collectionExplicitness
        trackExplicitness = result.trackExplicitness
        trackCount = result.trackCount
        trackTimeMillis = result.trackTimeMillis
        country = result.country
        currency = result.currency
        primaryGenreName = result.primaryGenreName
        contentAdvisoryRating = result.contentAdvisoryRating
        artworkUrl600 = result.artworkUrl600
        genreIDS = result.genreIDS
        genres = result.genres
    }
    
    @Relationship(inverse: \CurrentlyPlaying.podcast)
    var currentlyPlaying: CurrentlyPlaying? = nil
    var inLibrary = false
    @Relationship(inverse: \RSSFeed.podcast)
    var feed: RSSFeed? = nil
    var wrapperType: SearchResult.WrapperType? = nil
    var kind: String? = nil
    var artistID: Int? = nil
    var collectionID: Int? = nil
    var trackID: Int? = nil
    var artistName: String? = nil
    var collectionName: String? = nil
    var trackName: String? = nil
    var collectionCensoredName: String? = nil
    var trackCensoredName: String? = nil
    var artistViewURL: URL? = nil
    var collectionViewURL: URL? = nil
    var feedURL: URL? = nil
    var trackViewURL: URL? = nil
    var artworkUrl30: URL? = nil
    var artworkUrl60: URL? = nil
    var artworkUrl100: URL? = nil
    var collectionPrice: Int? = nil
    var trackPrice: Int? = nil
    var collectionHDPrice: Int? = nil
    var releaseDate: Date? = nil
    var collectionExplicitness: String? = nil
    var trackExplicitness: String? = nil
    var trackCount: Int? = nil
    var trackTimeMillis: Int? = nil
    var country: String? = nil
    var currency: String? = nil
    var primaryGenreName: String? = nil
    var contentAdvisoryRating: String? = nil
    var artworkUrl600: URL? = nil
    var genreIDS: [String]? = nil
    var genres: [String]? = nil

    init(collectionID: Int) {
        self.collectionID = collectionID
    }
}

extension Podcast {
    struct SearchResult: Codable, Hashable, Identifiable {
        var id: Int {
            switch wrapperType {
            case .track:
                return trackID ?? -1
            case .collection:
                return collectionID
            case .artist:
                return artistID ?? -1
            case nil:
                return -1
            }
        }

        let wrapperType: WrapperType?

        enum WrapperType: String, Codable, Hashable {
            case track, collection, artist
        }

        let kind: String?
        let artistID: Int?
        let collectionID: Int
        let trackID: Int?
        let artistName: String?
        let collectionName: String?
        let trackName: String?
        let collectionCensoredName: String?
        let trackCensoredName: String?
        let artistViewURL: URL?
        let collectionViewURL: URL?
        let feedURL: URL?
        let trackViewURL: URL?
        let artworkUrl30: URL?
        let artworkUrl60: URL?
        let artworkUrl100: URL?
        let collectionPrice: Int?
        let trackPrice: Int?
        let collectionHDPrice: Int?
        let releaseDate: Date?
        let collectionExplicitness: String?
        let trackExplicitness: String?
        let trackCount: Int?
        let trackTimeMillis: Int?
        let country: String?
        let currency: String?
        let primaryGenreName: String?
        let contentAdvisoryRating: String?
        let artworkUrl600: URL?
        let genreIDS: [String]?
        let genres: [String]?

        enum CodingKeys: String, CodingKey {
            case wrapperType = "wrapperType"
            case kind = "kind"
            case artistID = "artistId"
            case collectionID = "collectionId"
            case trackID = "trackId"
            case artistName = "artistName"
            case collectionName = "collectionName"
            case trackName = "trackName"
            case collectionCensoredName = "collectionCensoredName"
            case trackCensoredName = "trackCensoredName"
            case artistViewURL = "artistViewUrl"
            case collectionViewURL = "collectionViewUrl"
            case feedURL = "feedUrl"
            case trackViewURL = "trackViewUrl"
            case artworkUrl30 = "artworkUrl30"
            case artworkUrl60 = "artworkUrl60"
            case artworkUrl100 = "artworkUrl100"
            case collectionPrice = "collectionPrice"
            case trackPrice = "trackPrice"
            case collectionHDPrice = "collectionHdPrice"
            case releaseDate = "releaseDate"
            case collectionExplicitness = "collectionExplicitness"
            case trackExplicitness = "trackExplicitness"
            case trackCount = "trackCount"
            case trackTimeMillis = "trackTimeMillis"
            case country = "country"
            case currency = "currency"
            case primaryGenreName = "primaryGenreName"
            case contentAdvisoryRating = "contentAdvisoryRating"
            case artworkUrl600 = "artworkUrl600"
            case genreIDS = "genreIds"
            case genres = "genres"
        }
    }
}
