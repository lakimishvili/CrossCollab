//
//  EventDetailsView.swift
//  EventHub
//
//  Created by Bacho on 24.12.25.
//

import SwiftUI

struct EventDetailsView: View {
    @StateObject var viewModel: EventDetailsViewModel

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
                        Image("defaultEvent")
                            .resizable()
                            .scaledToFill()
                            .frame(height: 200)
                            .clipped()

                        VStack(alignment: .leading, spacing: 16) {

                            // MARK: - Tags
                            HStack(spacing: 8) {
                                Text(event.eventTypeName)
                                    .font(.system(size: 12, weight: .regular, design: .default))
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 6)
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(12)
                            }

                            // MARK: - Title
                            Text(event.title)
                                .font(.title2)

                            // MARK: - Info
                            VStack(alignment: .leading, spacing: 12) {
                                InfoRow(icon: "calendar", text:
                                    DateHelper.formatDate(
                                        event.startDateTime,
                                        format: "MMMM dd, yyyy"
                                    )
                                )

                                InfoRow(
                                    icon: "clock",
                                    text: "\(DateHelper.formatTime(event.startDateTime)) - \(DateHelper.formatTime(event.endDateTime))"
                                )

                                InfoRow(icon: "location.fill", text: event.location)

                                InfoRow(
                                    icon: "person.3.fill",
                                    text: "\(event.confirmedCount) registered, \(event.capacity - event.confirmedCount) spots left"
                                )
                            }

                            // MARK: - Register Button
                            VStack(spacing: 10) {
                                Divider()
                                Button {
                                    Task {
                                        await viewModel.registerForEvent()
                                    }
                                } label: {
                                    if viewModel.isRegistering {
                                        ProgressView()
                                            .tint(.white)
                                    } else {
                                        Text(buttonTitle(event: event))
                                            .font(.headline)
                                            .frame(maxWidth: .infinity)
                                    }
                                }
                                .padding()
                                .background(Color.black)
                                .foregroundColor(.white)
                                .cornerRadius(12)
                                .disabled(viewModel.isRegistering || viewModel.isRegistered)

                                Text("Registration closes at 5:00 PM.") //  ‼️ STATIC ‼️
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }

                            Divider()

                            // MARK: - About
                            VStack(alignment: .leading, spacing: 8) {
                                Text("About this event")

                                Text(event.description)
                                    .font(.body)
                                    .foregroundColor(.secondary)
                                Divider()
                            }

                            // MARK: - Agend  ‼️ STATIC ‼️
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Agenda")

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


                            // MARK: - Speakers ‼️ STATIC ‼️
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Featured Speakers")
                                
                                SpeakerRow(name: "Sarah Johnson",
                                           role: "VP of Human Resources",
                                           imageName: "defaultEvent")

                                SpeakerRow(name: "David Chen",
                                           role: "Lead Corporate Trainer",
                                           imageName: "defaultEvent")
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
    }

    // MARK: - Helpers
    private func buttonTitle(event: EventDetails) -> String {
        if viewModel.isRegistered {
            return "Registered"
        } else if event.isFull {
            return "Join Waitlist"
        } else {
            return "Register Now"
        }
    }
}
