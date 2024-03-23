//
//  iTunesService.swift
//  Lavender
//
//  Created by Brianna Zamora on 3/22/24.
//

import Foundation

struct iTunesAPI: WebService {
    var host = "itunes.apple.com"

    var countryCode: String {
        Locale.current.region?.identifier ?? "US"
    }

    func search(term: String) async throws -> SearchResult {
        guard let percentEncodedTerm = term.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            throw PodcastActorError.failedToAddPercentEncodingToTerm
        }
        return try await get(
            path: "search",
            parameters: [
                "term": percentEncodedTerm,
                "media": "podcast",
                "country": countryCode
            ]
        )
    }

    func lookupPodcast(collectionID: Int) async throws -> SearchResult {
        // https://itunes.apple.com/lookup?id=1251196416&country=US&media=podcast&entity=podcastEpisode&limit=100
        // https://itunes.apple.com/lookup?id=%3CcollectionId_forThePodcastShow%3E&media=podcast&entity=podcastEpisode&limit=100
        try await get(
            path: "lookup",
            parameters: [
                "id": "\(collectionID)",
                "country": countryCode,
                "media": "podcast",
                "entity": "podcast",
                "limit": "1"
            ]
        )
    }

    var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }

    struct SearchResult: Decodable {
        let resultCount: Int
        let results: [Podcast.SearchResult]
    }
}
