//
//  HomeView.swift
//  Lavender
//
//  Created by Brianna Zamora on 3/22/24.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationStack {
            List {
                UpNextSection()
            }
            .navigationTitle(LavenderScreen.home.title)
            .listStyle(.plain)
        }
    }
}

#Preview {
    HomeView()
}
