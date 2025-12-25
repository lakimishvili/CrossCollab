//
//  EventDetailsView.swift
//  EventHub
//
//  Created by Bacho on 24.12.25.
//

import SwiftUI

struct EventDetailsView: View {
    @StateObject var viewModel: EventDetailsViewModel
    @State private var showCancelAlert = false
    
    var body: some View {
        VStack(spacing: 0) {
            
            CustomNavigationBar(
                title: "Event Details",
                onBack: { viewModel.goBack() }
            )
            
            if viewModel.isLoading {
                Spacer()
                ProgressView("Loading...")
                Spacer()
            } else if let event = viewModel.event {
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        
                        // MARK: - Banner
                        PosterView(
                            imageURL: event.imageUrl,
                            size: 200
                        )

                        
                        VStack(alignment: .leading, spacing: 16) {
                            
                            // MARK: - Tags
                            HStack(spacing: 8) {
                                Text(event.eventTypeName)
                                    .font(.system(size: 12, weight: .regular))
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 6)
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(12)
                            }
                            
                            // MARK: - Title
                            Text(event.title)
                                .font(.title2.bold())
                            
                            // MARK: - Info
                            VStack(alignment: .leading, spacing: 12) {
                                InfoRow(
                                    icon: "calendar",
                                    text: DateHelper.formatDate(event.startDateTime, format: "MMMM dd, yyyy")
                                )
                                
                                InfoRow(
                                    icon: "clock",
                                    text: "\(DateHelper.formatTime(event.startDateTime)) - \(DateHelper.formatTime(event.endDateTime))"
                                )
                                
                                InfoRow(icon: "location.fill", text: event.location)
                                
                                InfoRow(
                                    icon: "person.3.fill",
                                    text: capacityText(event: event)
                                )
                            }
                            
                            // MARK: - Register Button
                            VStack(spacing: 10) {
                                Divider()
                                
                                Button {
                                    if viewModel.isRegistered {
                                        showCancelAlert = true
                                    } else {
                                        Task {
                                            await viewModel.toggleRegistration()
                                        }
                                    }
                                } label: {
                                    if viewModel.isRegistering {
                                        ProgressView()
                                            .tint(.white)
                                            .frame(maxWidth: .infinity)
                                    } else {
                                        Text(buttonTitle(event: event))
                                            .font(.headline)
                                            .frame(maxWidth: .infinity)
                                    }
                                }
                                .padding()
                                .background(buttonColor(event: event))
                                .foregroundColor(.white)
                                .cornerRadius(12)
                                .disabled(viewModel.isRegistering)
                                
                                Text(buttonSubtitle(event: event))
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                    .multilineTextAlignment(.center)
                            }
                            
                            Divider()
                            
                            // MARK: - About
                            VStack(alignment: .leading, spacing: 8) {
                                Text("About this event")
                                    .font(.headline)
                                
                                Text(event.description)
                                    .font(.body)
                                    .foregroundColor(.secondary)
                                
                                Divider()
                            }
                            
                            // MARK: - Agenda
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Agenda")
                                    .font(.headline)
                                
                                let agendaItems = [
                                    ("02:00 PM - Welcome & Introduction", "Overview of the workshop goals and key topics."),
                                    ("02:15 PM - The Art of Active Listening", "Interactive exercises on understanding and responding."),
                                    ("03:30 PM - Q&A and Closing Remarks", "Open forum and summary of key takeaways.")
                                ]
                                
                                ForEach(Array(agendaItems.enumerated()), id: \.offset) { index, item in
                                    AgendaRow(
                                        step: "\(index + 1)",
                                        title: item.0,
                                        subtitle: item.1,
                                        isLast: index == agendaItems.count - 1
                                    )
                                }
                                
                                Divider()
                            }
                            
                            // MARK: - Speakers
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Featured Speakers")
                                    .font(.headline)
                                
                                SpeakerRow(
                                    name: "Sarah Johnson",
                                    role: "VP of Human Resources",
                                    imageName: "pfp"
                                )
                                
                                SpeakerRow(
                                    name: "David Chen",
                                    role: "Lead Corporate Trainer",
                                    imageName: "pfp"
                                )
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.bottom, 32)
                }
            }
        }
        .navigationBarHidden(true)
        .task {
            await viewModel.loadEvent()
        }
        .alert("Cancel Registration?", isPresented: $showCancelAlert) {
            Button("Keep Registration", role: .cancel) {}
            Button("Cancel Registration", role: .destructive) {
                Task {
                    await viewModel.toggleRegistration()
                }
            }
        } message: {
            Text("Are you sure you want to cancel your registration for this event? This will free up your spot for someone on the waitlist.")
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
}

// MARK: - Helper Methods
private extension EventDetailsView {
    
    func buttonTitle(event: EventDetails) -> String {
        if viewModel.isRegistered {
            return "Cancel Registration"
        } else if event.isFull {
            return "Join Waitlist"
        } else {
            return "Register Now"
        }
    }
    
    func buttonColor(event: EventDetails) -> Color {
        if viewModel.isRegistered {
            return .red
        } else if event.isFull {
            return .orange
        } else {
            return .black
        }
    }
    
    func buttonSubtitle(event: EventDetails) -> String {
        if viewModel.isRegistered {
            return "Tap to cancel your registration"
        } else if event.isFull {
            return "You'll be added to the waitlist"
        } else {
            return "Registration closes at 5:00 PM"
        }
    }
    
    func capacityText(event: EventDetails) -> String {
        let spotsLeft = event.capacity - event.confirmedCount
        if event.isFull {
            return "\(event.confirmedCount) registered, Event is full"
        } else if spotsLeft == 1 {
            return "\(event.confirmedCount) registered, 1 spot left"
        } else {
            return "\(event.confirmedCount) registered, \(spotsLeft) spots left"
        }
    }
}
