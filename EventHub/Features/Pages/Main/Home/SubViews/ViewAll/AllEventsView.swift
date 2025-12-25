//
//  AllEventsView.swift
//  EventHub
//
//  Created by Bacho on 24.12.25.
//

import SwiftUI

struct AllEventsView: View {
    @StateObject var viewModel: HomeViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            CustomNavigationBar(
                title: "All Upcoming Events",
                onBack: { viewModel.goBack() }
            )
            List(viewModel.upcomingEvents, id: \.id) { event in
                EventCardView(
                    date: DateHelper.formatEventDate(event.startDateTime),
                    title: event.title,
                    time: DateHelper.formatEventTime(event.startDateTime),
                    location: event.location,
                    footer: DateHelper.formatEventFooter(event),
                    isDisabled: event.isFull
                )
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                .onTapGesture {
                    viewModel.viewEventDetails(eventId: event.id)
                }
                .listStyle(.plain)
            }
            .navigationBarHidden(true)
            .task {
                if viewModel.upcomingEvents.isEmpty {
                    await viewModel.fetchUpcomingEvents()
                }
            }
            .refreshable {
                if viewModel.upcomingEvents.isEmpty {
                    await viewModel.fetchUpcomingEvents()
                }
            }
        }
    }
}

#Preview {
    AllEventsView(viewModel: HomeViewModel())
}
