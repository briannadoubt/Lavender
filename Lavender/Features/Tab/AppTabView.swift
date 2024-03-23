//
//  AppTabView.swift
//  Lavender
//
//  Created by Brianna Zamora on 3/22/24.
//

import SwiftUI

struct AppTabView: View {
    @SceneStorage("current-tab") var tab: Tab = .home
    var body: some View {
        TabView(selection: $tab) {
            ForEach(Tab.allCases) { screen in
                screen.body
            }
        }
    }
}

#Preview {
    AppTabView()
}
