//
//  LavenderApp.swift
//  Lavender
//
//  Created by Brianna Zamora on 3/20/24.
//

import SwiftUI
import BackgroundTasks

@main
struct LavenderApp: App {
    var persistence = Persistence()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .task {
                    let request = BGAppRefreshTaskRequest(identifier: "syncPodcasts")
                    try? BGTaskScheduler.shared.submit(request)
                }
        }
        .modelContainer(persistence.sharedModelContainer)
        .backgroundTask(.appRefresh("syncPodcasts")) {
            let container = persistence.sharedModelContainer
            let lavendar = Lavendar(modelContainer: container)
            await lavendar.syncPodcasts()
        }
    }
}

