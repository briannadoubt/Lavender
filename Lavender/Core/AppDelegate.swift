//
//  AppDelegate.swift
//  Lavender
//
//  Created by Brianna Zamora on 4/3/24.
//

import Foundation
import UIKit
import AVKit
import MediaPlayer

@objc
final class AppDelegate: NSObject, UIApplicationDelegate {

    static var shared: AppDelegate!

    @MainActor
    let queue: AVQueuePlayer

    @MainActor
    let session: MPNowPlayingSession

    override init() {
        queue = AVQueuePlayer()
        session = MPNowPlayingSession(players: [queue])
        super.init()
    }
}
