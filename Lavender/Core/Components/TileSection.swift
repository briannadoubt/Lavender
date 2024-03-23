//
//  TileSection.swift
//  Lavender
//
//  Created by Brianna Zamora on 3/21/24.
//

import SwiftUI

struct TileSection<Destination: View, Content: View>: View {
    var header: String
    @ViewBuilder var headerDestination: () -> Destination
    @ViewBuilder var content: () -> Content
    var body: some View {
        Section {
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack {
                    content()
                }
                .padding()
            }
        } header: {
            HStack {
                NavigationLink {
                    headerDestination()
                } label: {
                    HStack {
                        Text(header)
                        Image(systemName: "chevron.right")
                    }
                    .font(.title3)
                    .bold()
                }
                .buttonStyle(.plain)
                Spacer()
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    NavigationStack {
        TileSection(header: "Meow") {
            Text("You clicked on meow!")
        } content: {
            Text("Meow")
            Text("Meow")
            Text("Meow")
            Text("Meow")
            Text("Meow")
        }
    }

}
