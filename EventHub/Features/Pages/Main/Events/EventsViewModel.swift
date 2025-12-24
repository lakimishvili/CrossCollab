//
//  EventsViewModel.swift
//  EventHub
//
//  Created by Bacho on 22.12.25.
//

import Combine
import Foundation

enum ViewMode: String, CaseIterable {
    case list = "List"
    case calendar = "Calendar"
}

@MainActor
final class EventsViewModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published var myRegistrations: [UserRegistration] = []
    @Published var events: [Event] = [] 
    @Published var viewMode: ViewMode = .list
    @Published var selectedDate: Date = Date()
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    // MARK: - Dependencies
    weak var coordinator: MainCoordinatorProtocol?
    private let eventService: EventService
    private weak var appState: AppState?
    
    // MARK: - Computed Properties
    var upcomingEvent: Event? {
        events.first { event in
            guard let eventDate = DateHelper.parseDate(event.startDateTime) else { return false }
            return eventDate > Date()
        }
    }
    
    var eventsForSelectedDate: [Event] {
        events.filter { event in
            guard let eventDate = DateHelper.parseDate(event.startDateTime) else { return false }
            return Calendar.current.isDate(eventDate, inSameDayAs: selectedDate)
        }
    }
    
    var allMyEvents: [Event] {
        events
    }
    
    // MARK: - Init
    init(
        coordinator: MainCoordinatorProtocol? = nil,
        eventService: EventService = EventService.shared,
        appState: AppState? = nil
    ) {
        self.coordinator = coordinator
        self.eventService = eventService
        self.appState = appState
    }
    
    // MARK: - Fetch User Registrations
    func fetchMyRegistrations() {
        guard let userId = appState?.currentUserId else {
            errorMessage = "User not logged in"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let registrations = try await eventService.getUserRegistrations(userId: userId)
                
                await MainActor.run {
                    self.myRegistrations = registrations.filter { $0.status != .cancelled }
                    
                    // Convert UserRegistration to Event model
                    self.events = self.myRegistrations.map { registration in
                        Event(
                            id: registration.eventId,
                            title: registration.eventTitle,
                            eventTypeName: registration.eventType,
                            startDateTime: registration.startDateTime,
                            location: registration.location,
                            status: registration.status
                        )
                    }
                    
                    self.isLoading = false
                }
                
            } catch let error as NetworkError {
                await MainActor.run {
                    self.isLoading = false
                    self.errorMessage = error.localizedDescription
                }
            } catch {
                await MainActor.run {
                    self.isLoading = false
                    self.errorMessage = "Failed to load registrations"
                }
            }
        }
    }
    
    // MARK: - Cancel Registration
    func cancelRegistration(_ registration: UserRegistration) {
        Task {
            do {
                try await eventService.cancelRegistration(registrationId: registration.registrationId)
                
                fetchMyRegistrations()
                
            } catch let error as NetworkError {
                await MainActor.run {
                    self.errorMessage = error.localizedDescription
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = "Failed to cancel registration"
                }
            }
        }
    }
    
    // MARK: - Navigate to Event Details
    func viewEventDetails(eventId: Int) {
        // TODO: Navigate to event details when implemented
        print("Navigate to event \(eventId)")
    }
}
