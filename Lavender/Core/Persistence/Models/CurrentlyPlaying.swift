//
//  CurrentlyPlaying.swift
//  Lavender
//
//  Created by Brianna Zamora on 3/28/24.
//

import Foundation
import SwiftData
import SwiftUI
import FeedKit

@Model
final class CurrentlyPlaying {
    @Relationship(inverse: \Item.currentlyPlaying)
    var feedItem: Item? = nil
    var podcast: Podcast? = nil
    var player: Player? = nil
    var isPlaying: Bool = false
    var playPosition = 0.0
    var duration = 0.0

    init() {}
}
