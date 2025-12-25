//
//  CategoryList.swift
//  EventHub
//
//  Created by Bacho on 25.12.25.
//

import SwiftUI

struct CategoryList: View {
    @StateObject var viewModel: CategoryViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Horizontal Chips
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(viewModel.categories, id: \.self) { category in
                        categoryChip(category)
                    }
                }
            }
            
            // Results Section
            if viewModel.isLoading {
                ProgressView().frame(maxWidth: .infinity).padding()
            } else if viewModel.events.isEmpty {
                Text("No \(viewModel.selectedCategory) events found.")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity).padding()
            } else {
                VStack(spacing: 12) {
                    ForEach(viewModel.events) { event in
                        EventCardView(
                            date: DateHelper.formatEventDate(event.startDateTime),
                            title: event.title,
                            time: DateHelper.formatEventTime(event.startDateTime),
                            location: event.location,
                            footer: DateHelper.formatEventFooter(event),
                            isDisabled: event.isFull
                        )
                        .onTapGesture {
                            viewModel.viewDetails(id: event.id)
                        }
                    }
                }
            }
        }
        .task {
            await viewModel.fetchEvents()
        }
    }
    
    private func categoryChip(_ name: String) -> some View {
        let isSelected = viewModel.selectedCategory == name
        return Button(action: {
            Task { await viewModel.selectCategory(name) }
        }) {
            Text(name)
                .font(.system(size: 14, weight: .medium))
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(isSelected ? Color.blue : Color.blue.opacity(0.1))
                .foregroundColor(isSelected ? .white : .blue)
                .clipShape(Capsule())
        }
    }
}
