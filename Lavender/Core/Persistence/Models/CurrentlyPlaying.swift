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
    @Attribute(.transformable(by: UIImageDataTransformer.self))
    var image: UIImage? = nil

    init() {}
}
