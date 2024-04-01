//
//  LavenderTabView.swift
//  Lavender
//
//  Created by Brianna Zamora on 3/22/24.
//

import SwiftUI

struct LavenderTabView: View {
    @SceneStorage("current-tab") var tab: LavenderScreen = .home

    var body: some View {
        TabView(selection: $tab) {
            ForEach(LavenderScreen.allCases) { screen in
                Group {
                    switch screen {
                    case .home:
                        HomeView()
                    case .search:
                        PodcastSearch()
                    default:
                        Text(screen.title)
                    }
                }
                .tabItem { screen.label }
                .tag(screen)
            }
        }
    }
}

#Preview {
    LavenderTabView()
}
