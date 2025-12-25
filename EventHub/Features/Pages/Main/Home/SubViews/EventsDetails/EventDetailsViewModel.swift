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
    
    private var registrationId: Int?
    
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
        guard let userId = appState?.currentUserId else {
            return
        }
                
        do {
            let registration = try await eventService.getUserRegistration(
                userId: userId,
                eventId: eventId
            )
            
            if let reg = registration, reg.status != .cancelled {
                isRegistered = true
                registrationId = reg.registrationId
            } else {
                isRegistered = false
                registrationId = nil
            }
        } catch {
            isRegistered = false
            registrationId = nil
        }
    }
    
    func toggleRegistration() async {
        if isRegistered {
            await cancelRegistration()
        } else {
            await registerForEvent()
        }
    }
    
    private func registerForEvent() async {
        guard let userId = appState?.currentUserId else {
            errorMessage = "Please log in"
            return
        }
        
        isRegistering = true
        
        do {
            let registration = try await eventService.registerForEvent(eventId: eventId, userId: userId)
            
            self.isRegistered = true
            self.registrationId = registration.id
            self.isRegistering = false
        
        } catch {
            self.isRegistering = false
            await loadEvent()
            await checkRegistrationStatus()
            
            if !isRegistered {
                errorMessage = "Failed to register. Please try again."
            }
        }
    }
    
    private func cancelRegistration() async {
        guard let regId = registrationId else {
            errorMessage = "Registration not found"
            return
        }
        
        isRegistering = true
        
        do {
            try await eventService.cancelRegistration(registrationId: regId)
            
            
            self.isRegistered = false
            self.registrationId = nil
            self.isRegistering = false
            
            await loadEvent()
            
        } catch {
            
            self.isRegistering = false
            
            await loadEvent()
            await checkRegistrationStatus()
            
            if isRegistered {
                errorMessage = "Failed to cancel registration"
            } else {
                print(" Cancellation actually succeeded despite error")
            }
        }
    }
    
    func goBack() {
        coordinator?.pop()
    }
}
