//
//  LavenderScreen.swift
//  Lavender
//
//  Created by Brianna Zamora on 3/22/24.
//

import SwiftUI

enum LavenderScreen: String, CaseIterable, Identifiable {
    case home
//    case browse
//    case topCharts
//    case library
    case search

    var id: String { rawValue }

    var title: String {
        switch self {
        case .home:
            return "Home"
//        case .browse:
//            return "Browse"
//        case .topCharts:
//            return "Top Charts"
//        case .library:
//            return "Library"
        case .search:
            return "Search"
        }
    }

    var icon: String {
        switch self {
        case .home:
            return "house"
//        case .browse:
//            return "square.grid.2x2"
//        case .topCharts:
//            return "list.number"
        case .search:
            return "magnifyingglass"
//        case .library:
//            return "square.stack"
        }
    }

    @ViewBuilder
    var label: some View {
        Label(title, systemImage: icon)
    }
}

#Preview {
    Group {
        LavenderScreen.home.label
    }
}
