//
//  WebService.swift
//  Lavender
//
//  Created by Brianna Zamora on 3/22/24.
//

import Foundation

protocol WebService {
    var scheme: String { get }
    var host: String { get }
    var session: URLSession { get }
    var decoder: JSONDecoder { get }
}

extension WebService {
    var scheme: String { "https" }
    var session: URLSession { URLSession.shared }
    var decoder: JSONDecoder { JSONDecoder() }

    func get<T: Decodable>(path: String, parameters: [String: String]? = nil) async throws -> T {
        try await decode(
            execute(
                request: URLRequest(
                    url: buildURL(
                        path: path,
                        parameters: parameters
                    )
                )
            )
        )
    }

    private func buildURL(path: String, parameters: [String: String]?) throws-> URL {
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = path
        urlComponents.queryItems = parameters?.map { (key: String, value: String) in
            URLQueryItem(name: key, value: value)
        }
        guard let url = urlComponents.url else {
            throw URLError(.badURL)
        }
        return url
    }

    func decode<T: Decodable>(_ data: Data) throws -> T {
        try decoder.decode(T.self, from: data)
    }

    func execute(request: URLRequest) async throws -> Data {
        let (data, urlResponse) = try await URLSession.shared.data(for: request)
        print(String(data: data, encoding: .utf8) ?? "{ empty response }")
        guard let httpURLResponse = urlResponse as? HTTPURLResponse else {
            throw URLError(.cannotParseResponse)
        }
        guard httpURLResponse.statusCode >= 200 && httpURLResponse.statusCode < 300 else {
            throw URLError(.badServerResponse)
        }
        return data
    }
}
