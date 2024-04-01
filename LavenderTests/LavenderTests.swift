//
//  LavenderTests.swift
//  LavenderTests
//
//  Created by Brianna Zamora on 3/20/24.
//

@testable import Lavender
import XCTest
import SwiftData

final class LavenderTests: XCTestCase {
    // Subject under test
    var lavender: Lavender!
    var container: ModelContainer!

    override func setUpWithError() throws {
        // Set up subject under test
        container = try ModelContainer(
            for: RSSFeed.self,
            Podcast.self,
            configurations: ModelConfiguration(
                isStoredInMemoryOnly: true
            )
        )
        lavender = Lavender(modelContainer: container)
    }

    override func tearDownWithError() throws {
        lavender = nil
        container = nil
    }

    func testSearch() {

    }
}
