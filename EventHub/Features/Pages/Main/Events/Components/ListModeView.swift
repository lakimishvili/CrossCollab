//
//  ListModeView.swift
//  EventHub
//
//  Created by Bacho on 24.12.25.
//

import SwiftUI

struct ListModeView: View {
    @ObservedObject var viewModel: EventsViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                Text("All My Events")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                
                ForEach(viewModel.allMyEvents) { event in
                    EventCardView(
                        date: DateHelper.formatEventDate(event.startDateTime),
                        title: event.title,
                        time: DateHelper.formatEventTime(event.startDateTime),
                        location: event.location,
                        footer: formatStatusFooter(event),
                        isDisabled: false
                    )
                    .onTapGesture {
                        viewModel.viewEventDetails(eventId: event.id)
                    }
                }
            }
            .padding()
        }
    }
    
    private func formatStatusFooter(_ event: Event) -> String {
        if let status = event.status {
            return status.rawValue
        }
        return "Registered"
    }
}
