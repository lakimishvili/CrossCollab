//
//  EventDetailsViewModel.swift
//  EventHub
//
//  Created by Bacho on 24.12.25.
//

import Foundation

@MainActor
final class EventDetailsViewModel: ObservableObject {
    
    @Published var event: EventDetails?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var isRegistering = false
    @Published var isRegistered = false
    
    private let eventId: Int
    private let eventService: EventService
    private weak var appState: AppState?
    weak var coordinator: MainCoordinatorProtocol?
    
    init(
        eventId: Int,
        eventService: EventService = EventService.shared,
        appState: AppState? = nil,
        coordinator: MainCoordinatorProtocol? = nil
    ) {
        self.eventId = eventId
        self.eventService = eventService
        self.appState = appState
        self.coordinator = coordinator
    }
    
    func loadEvent() async {
        isLoading = true
        
        do {
            let details = try await eventService.getEventDetails(id: eventId)
            event = details
            isLoading = false
            
            await checkRegistrationStatus()
            
        } catch {
            errorMessage = "Failed to load event"
            isLoading = false
        }
    }
    
    private func checkRegistrationStatus() async {
        guard let userId = appState?.currentUserId else { return }
        
        do {
            let registration = try await eventService.getUserRegistration(
                userId: userId,
                eventId: eventId
            )
            isRegistered = registration != nil && registration?.status != .cancelled
        } catch {
            isRegistered = false
        }
    }
    
    func registerForEvent() async {
        guard let userId = appState?.currentUserId else {
            errorMessage = "Please log in"
            return
        }
        
        isRegistering = true
        
        do {
            _ = try await eventService.registerForEvent(eventId: eventId, userId: userId)
            self.isRegistered = true
            
            if var currentEvent = self.event {
                currentEvent.confirmedCount += 1
                self.event = currentEvent
            }
            
            self.isRegistering = false
            
        } catch {
            errorMessage = "Failed to register"
            isRegistering = false
        }
    }
    
    func goBack() {
        coordinator?.pop()
    }
}
