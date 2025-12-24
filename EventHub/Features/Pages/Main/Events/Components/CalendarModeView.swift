//
//  CalendarModeView.swift
//  EventHub
//
//  Created by Bacho on 24.12.25.
//

import SwiftUI

struct CalendarModeView: View {
    @ObservedObject var viewModel: EventsViewModel 
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                
                // Upcoming Event
                if let upcomingEvent = viewModel.upcomingEvent {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Upcoming Event")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        NextEventCard(event: upcomingEvent)
                    }
                    
                    Divider()
                        .padding(.horizontal)
                }
                
                // Calendar
                CalendarPicker(selectedDate: $viewModel.selectedDate)
                    .padding(.horizontal)
                
                Divider()
                    .padding(.horizontal)
                
                // Events for Selected Date
                VStack(alignment: .leading, spacing: 12) {
                    Text("Events on \(formattedDate(viewModel.selectedDate))")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    if viewModel.eventsForSelectedDate.isEmpty {
                        Text("No events on this day")
                            .foregroundColor(.secondary)
                            .padding(.horizontal)
                            .padding(.top, 8)
                    } else {
                        ForEach(viewModel.eventsForSelectedDate) { event in
                            EventDetailCard(event: event)
                                .onTapGesture {
                                    viewModel.viewEventDetails(eventId: event.id)
                                }
                        }
                    }
                }
            }
            .padding(.vertical)
        }
        .background(Color(.systemGray6))
    }
    
    private func formattedDate(_ date: Date) -> String {
        date.formatted(date: .abbreviated, time: .omitted)
    }
}
