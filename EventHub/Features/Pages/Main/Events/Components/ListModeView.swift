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
                    EventDetailCard(event: event)
                        .onTapGesture {
                            viewModel.viewEventDetails(eventId: event.id)
                        }
                }
            }
            .padding(.vertical)
        }
        .background(Color(.systemGray6))
    }
}
