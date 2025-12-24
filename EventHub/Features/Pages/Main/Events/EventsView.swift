//
//  EventsView.swift
//  EventHub
//
//  Created by Bacho on 22.12.25.
//

import SwiftUI
import MapKit

struct EventsView: View {
    @StateObject var viewModel: EventsViewModel
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                
                Picker("", selection: $viewModel.viewMode) {
                    ForEach(ViewMode.allCases, id: \.self) { mode in
                        Text(mode.rawValue).tag(mode)
                    }
                }
                .pickerStyle(.segmented)
                .padding()
                
                if viewModel.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                } else if let error = viewModel.errorMessage {
                    VStack(spacing: 12) {
                        Text(error)
                            .foregroundColor(.red)
                        Button("Retry") {
                            viewModel.fetchMyRegistrations()
                        }
                    }
                    
                } else if viewModel.events.isEmpty {
                    EmptyMyEventsView()
                    
                } else {
                    if viewModel.viewMode == .list {
                        ListModeView(viewModel: viewModel)
                    } else {
                        CalendarModeView(viewModel: viewModel)
                    }
                }
            }
            .navigationTitle("My Events")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                viewModel.fetchMyRegistrations()
            }
            .refreshable {
                viewModel.fetchMyRegistrations()
            }
        }
    }
}

#Preview {
    EventsView(viewModel: EventsViewModel())
}
