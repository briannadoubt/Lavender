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
        let url = try buildURL(
            path: path,
            parameters: parameters
        )
        let request = URLRequest(url: url)
        let data = try await execute(request: request)
        let result: T = try decode(data)
        return result
    }

    private func buildURL(path: String, parameters: [String: String]?) throws -> URL {
        let parametersString = (parameters ?? [:]).map({"\($0)=\($1)"}).joined(separator: "&")
        guard let url = URL(string: "\(scheme)://\(host)/\(path)?\(parametersString)") else {
            assertionFailure("WHY")
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
