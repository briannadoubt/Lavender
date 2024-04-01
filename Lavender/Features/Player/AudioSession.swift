//
//  AudioSession.swift
//  Lavender
//
//  Created by Brianna Zamora on 3/28/24.
//

import Foundation
import Logs
import Dependencies
import AVKit

//@Logging
//struct AudioSession: DependencyKey {
//    public static var liveValue: AVAudioSession = {
//        do {
////            try AVAudioSession.sharedInstance().setMode(.spokenAudio)
////            try AVAudioSession.sharedInstance().setCategory(
////                .playback,
////                mode: .spokenAudio,
////                policy: .longFormAudio,
////                options: [.allowAirPlay, .duckOthers]
////            )
//            try AVAudioSession.sharedInstance().setCategory(.playback)
//            #if os(visionOS)
//            try AVAudioSession.sharedInstance().setIsNowPlayingCandidate(true)
//            try AVAudioSession.sharedInstance().setIntendedSpatialExperience(.headTracked(soundStageSize: .small, anchoringStrategy: .front))
//            #endif
//        } catch {
//            Self.logger.error("Failed to configure AVAudioSession.sharedInstance() with error: \(error)")
//        }
//        return AVAudioSession.sharedInstance()
//    }()
//}
//
//extension DependencyValues {
//    var audioSession: AVAudioSession {
//        get { self[AudioSession.self] }
//        set { self[AudioSession.self] = newValue }
//    }
//}
