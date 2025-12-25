//
//  BrowseView.swift
//  EventHub
//
//  Created by Bacho on 22.12.25.
//

import SwiftUI

struct BrowseView: View {
    
    @StateObject private var viewModel: BrowseViewModel
    
    init(viewModel: BrowseViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            BrowseHeaderView()
            
            EventSearchView(text: $viewModel.searchText)
            
            if !viewModel.eventTypes.isEmpty {
                CategoryChipsView(
                    categories: viewModel.eventTypes.map { $0.name },
                    selectedIndex: viewModel.selectedCategoryIndex,
                    onSelect: { index in
                        viewModel.selectedCategoryIndex = index
                    }
                )
                .padding(.vertical, 8)
                .background(Color("customWhite"))
            }
            
            // Loading State
            if viewModel.isLoading {
                Spacer()
                ProgressView()
                Spacer()
            }
            
            // Error State
            else if let errorMessage = viewModel.errorMessage {
                Spacer()
                VStack(spacing: 12) {
                    Text(errorMessage)
                        .font(.subheadline)
                        .foregroundColor(.red)
                    
                    Button("Retry") {
                        Task {
                            await viewModel.fetchEvents()
                        }
                    }
                    .font(.subheadline)
                    .foregroundColor(.blue)
                }
                Spacer()
            }
            
            // Empty State
            else if viewModel.events.isEmpty {
                Spacer()
                VStack(spacing: 8) {
                    Image(systemName: "calendar.badge.exclamationmark")
                        .font(.system(size: 48))
                        .foregroundColor(.gray)
                    
                    Text("No events found")
                        .font(.headline)
                        .foregroundColor(.gray)
                    
                    Text("Try adjusting your filters")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                Spacer()
            }
            
            // Events List
            else {
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(viewModel.events) { event in
                            BrowseEventCardView(
                                month: DateHelper.getMonthDay(event.startDateTime).month,
                                day: DateHelper.getMonthDay(event.startDateTime).day,
                                category: event.eventTypeName,
                                title: event.title,
                                time: formatEventTime(event.startDateTime),
                                location: event.location,
                                registeredText: "\(event.confirmedCount) registered",
                                spotsText: formatSpotsText(event),
                                statusText: event.isFull ? "Full" : "Available",
                                isDisabled: event.isFull
                            )
                            .onTapGesture {
                                viewModel.viewEventDetails(eventId: event.id)
                            }
                        }
                    }
                    .padding()
                }
            }
        }
        .background(Color("customWhite"))
        .navigationBarHidden(true)
        .task {
            if viewModel.events.isEmpty {
                await viewModel.fetchEventTypes()
                await viewModel.fetchEvents()
            }
        }
        .refreshable {
            if viewModel.events.isEmpty {
                await viewModel.fetchEvents()
            }
        }
    }
    
    // MARK: - Helper: Format Time
    private func formatEventTime(_ dateString: String) -> String {
        guard let date = DateHelper.parseDate(dateString) else { return "" }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        let startTime = formatter.string(from: date)
        
        // Add 2 hours for end time (approximate)
        let endDate = date.addingTimeInterval(7200)
        let endTime = formatter.string(from: endDate)
        
        return "\(startTime) - \(endTime)"
    }
    
    // MARK: - Helper: Format Spots
    private func formatSpotsText(_ event: EventListItem) -> String {
        let spotsLeft = event.capacity - event.confirmedCount
        
        if event.isFull {
            return "0 spots left"
        } else {
            return "\(spotsLeft) spots left"
        }
    }
}

#Preview {
    BrowseView(viewModel: BrowseViewModel())
}
