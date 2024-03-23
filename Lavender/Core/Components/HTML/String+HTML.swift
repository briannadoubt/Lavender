//
//  String+HTML.swift
//  Lavender
//
//  Created by Brianna Zamora on 3/22/24.
//

import Foundation

extension String {
    var htmlToNSAttributed: NSAttributedString {
        guard let data = data(using: .utf8) else { return NSAttributedString(string: self) }
        do {
            return try NSAttributedString(
                data: data,
                options: [
                    .documentType: NSAttributedString.DocumentType.html,
                    .characterEncoding: String.Encoding.utf8.rawValue
                ],
                documentAttributes: nil
            )
        } catch {
            return NSAttributedString(string: self)
        }
    }

    var htmlToString: String {
        htmlToNSAttributed.string
    }

    var htmlToAttributed: AttributedString {
        do {
            return try AttributedString(htmlToNSAttributed, including: \.swiftUI)
        } catch {
            return AttributedString(stringLiteral: self)
        }
    }
}
