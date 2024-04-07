//
//  URL+withSecureHost.swift
//  Lavender
//
//  Created by Brianna Zamora on 4/5/24.
//

import Foundation

extension URL {
    var withSecureHost: URL {
        get throws {
            var components = URLComponents(url: self, resolvingAgainstBaseURL: true)
            guard components?.scheme == "https" else {
                components?.scheme = "https"
                guard let url = components?.url else {
                    throw URLError(.badURL)
                }
                Self.logger.log("Performed secure upgrade from \(self) to \(url)")
                return url
            }
            return self
        }
    }
}

extension URL: HasLogger {}
