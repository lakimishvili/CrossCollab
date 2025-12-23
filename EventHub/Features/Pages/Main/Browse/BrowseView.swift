//
//  BrowseView.swift
//  EventHub
//
//  Created by Bacho on 22.12.25.
//

import SwiftUI

struct BrowseView: View {

    @StateObject private var viewModel: BrowseViewModel
    @State private var searchText = ""

    private let categories = [
        "All",
        "Team Building",
        "Sports",
        "Workshop",
        "Happy Friday",
        "Cultural",
        "Training",
        "Social"
    ]

    init(viewModel: BrowseViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack(spacing: 0) {
            BrowseHeaderView()
            EventSearchView(text: $searchText)
            CategoryChipsView(
                categories: categories,
                selectedIndex: 0
            )
            .padding(.vertical, 8)
            .background(Color("customWhite"))

            ScrollView {
                LazyVStack(spacing: 12) {

                    BrowseEventCardView(
                        month: "JAN",
                        day: "18",
                        category: "Team Building",
                        title: "Annual Team Building Summit",
                        time: "09:00 AM - 05:00 PM",
                        location: "Grand Conference Hall",
                        registeredText: "142 registered",
                        spotsText: "8 spots left",
                        statusText: "Available",
                        isDisabled: false
                    )

                    BrowseEventCardView(
                        month: "JAN",
                        day: "26",
                        category: "Workshop",
                        title: "Tech Talk: AI in Business Operations",
                        time: "11:00 AM - 12:30 PM",
                        location: "Virtual Meeting",
                        registeredText: "100 registered",
                        spotsText: "0 spots left",
                        statusText: "Full",
                        isDisabled: true
                    )
                }
                .padding()
            }
        }
        .background(Color("customWhite"))
        .navigationBarHidden(true)
    }
}




#Preview {
    BrowseView(viewModel: BrowseViewModel())
}
