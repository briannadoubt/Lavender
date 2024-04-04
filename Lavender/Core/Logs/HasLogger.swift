//
//  HasLogger.swift
//  Lavender
//
//  Created by Brianna Zamora on 4/3/24.
//

import SwiftUI
import os

protocol HasLogger {
    static var logger: Logger { get }
}

extension HasLogger {
    static var logger: Logger {
        Logger(
            subsystem: Bundle.main.bundleIdentifier
                ?? Bundle.main.bundlePath.components(separatedBy: "/").last
                ?? "App",
            category: String(describing: Self.self)
        )
    }
}
