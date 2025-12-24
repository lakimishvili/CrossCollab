//
//  EventDetailsView.swift
//  EventHub
//
//  Created by Bacho on 24.12.25.
//

import SwiftUI

struct EventDetailsView: View {
    @StateObject var viewModel: EventDetailsViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            CustomNavigationBar(
                title: "Event Details",
                onBack: { dismiss() }
            )
            
            if viewModel.isLoading {
                Spacer()
                ProgressView("Loading...")
                Spacer()
                
            } else if let event = viewModel.event {
                ZStack(alignment: .bottom) {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 20) {
                            
                            Image("defaultEvent")
                                .resizable()
                                .scaledToFill()
                                .frame(height: 200)
                                .clipped()
                                .cornerRadius(12)
                            
                            VStack(alignment: .leading, spacing: 16) {
                                
                                Text(event.eventTypeName)
                                    .font(.subheadline)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(Color.blue.opacity(0.1))
                                    .foregroundColor(.blue)
                                    .cornerRadius(8)
                                
                                Text(event.title)
                                    .font(.title.bold())
                                
                                VStack(alignment: .leading, spacing: 12) {
                                    InfoRow(icon: "calendar", text: DateHelper.formatDate(event.startDateTime, format: "MMM dd, yyyy"))
                                    
                                    InfoRow(icon: "clock", text: "\(DateHelper.formatTime(event.startDateTime)) - \(DateHelper.formatTime(event.endDateTime))")
                                    
                                    InfoRow(icon: "mappin.and.ellipse", text: event.location)
                                    
                                    InfoRow(icon: "person.3", text: "\(event.confirmedCount) / \(event.capacity) registered")
                                }
                                
                                Divider()
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("About")
                                        .font(.headline)
                                    
                                    Text(event.description)
                                        .foregroundColor(.secondary)
                                }
                                
                                if !event.tags.isEmpty {
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text("Tags")
                                            .font(.headline)
                                        
                                        ScrollView(.horizontal, showsIndicators: false) {
                                            HStack(spacing: 8) {
                                                ForEach(event.tags, id: \.self) { tag in
                                                    Text(tag)
                                                        .font(.caption)
                                                        .padding(.horizontal, 12)
                                                        .padding(.vertical, 6)
                                                        .background(Color.gray.opacity(0.1))
                                                        .cornerRadius(12)
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                            
                            Color.clear.frame(height: 80)
                        }
                        .padding()
                    }
                    
                    VStack(spacing: 0) {
                        Divider()
                        
                        Button {
                            Task {
                                await viewModel.registerForEvent()
                            }
                        } label: {
                            if viewModel.isRegistering {
                                ProgressView()
                                    .tint(.white)
                            } else if viewModel.isRegistered {
                                Text("Registered ✓")
                                    .font(.headline)
                            } else if event.isFull {
                                Text("Join Waitlist")
                                    .font(.headline)
                            } else {
                                Text("Register Now")
                                    .font(.headline)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(buttonColor(event: event))
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .padding()
                        .disabled(viewModel.isRegistering || viewModel.isRegistered)
                    }
                    .background(Color.white)
                }
            }
        }
        .navigationBarHidden(true)
        .task {
            await viewModel.loadEvent()
        }
        .alert("Error", isPresented: .constant(viewModel.errorMessage != nil)) {
            Button("OK") {
                viewModel.errorMessage = nil
            }
        } message: {
            if let error = viewModel.errorMessage {
                Text(error)
            }
        }
    }
    
    private func buttonColor(event: EventDetails) -> Color {
        if viewModel.isRegistered {
            return .green
        } else if event.isFull {
            return .orange
        } else {
            return .black
        }
    }
}

struct InfoRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .foregroundColor(.gray)
                .frame(width: 20)
            
            Text(text)
                .font(.body)
        }
    }
}
