//
//  EventService.swift
//  EventHub
//
//  Created by Bacho on 24.12.25.
//

import Foundation

final class EventService {
    
    // MARK: - Dependencies
    private let networkService: EventServiceProtocol
    
    // MARK: - Singleton
    static let shared = EventService(
        networkService: RealEventService.shared 
    )
    
    // MARK: - Init
    init(networkService: EventServiceProtocol) {
        self.networkService = networkService
    }
    
    // MARK: - Get Event Types
    func getEventTypes() async throws -> [EventType] {
        return try await networkService.getEventTypes()
    }
    
    // MARK: - Get Events
    func getEvents(filters: EventFilters? = nil) async throws -> [EventListItem] {
        return try await networkService.getEvents(filters: filters)
    }
    
    // MARK: - Get Upcoming Events (for Home)
    func getUpcomingEvents(limit: Int = 5) async throws -> [EventListItem] {
        let allEvents = try await networkService.getEvents(filters: nil)
        
        let upcomingEvents = allEvents.filter { event in
            DateHelper.isUpcoming(event.startDateTime)
        }
        
        return Array(upcomingEvents.prefix(limit))
    }
    
    // MARK: - Get Event Details
    func getEventDetails(id: Int) async throws -> EventDetails {
        return try await networkService.getEventDetails(id: id)
    }
    
    // MARK: - Get User Registrations
    func getUserRegistrations(userId: Int) async throws -> [UserRegistration] {
        return try await networkService.getUserRegistrations(userId: userId)
    }
    
    // MARK: - Register for Event
    func registerForEvent(eventId: Int, userId: Int) async throws -> EventRegistration {
        return try await networkService.registerForEvent(eventId: eventId, userId: userId)
    }
    
    // MARK: - Cancel Registration
    func cancelRegistration(registrationId: Int) async throws {
        try await networkService.cancelRegistration(registrationId: registrationId)
    }
    
    // MARK: - Check if User is Registered
    func isUserRegistered(userId: Int, eventId: Int) async throws -> Bool {
        let registrations = try await getUserRegistrations(userId: userId)
        return registrations.contains { $0.eventId == eventId && $0.status != .cancelled }
    }
    
    // MARK: - Get User Registration for Event
    func getUserRegistration(userId: Int, eventId: Int) async throws -> UserRegistration? {
        let registrations = try await getUserRegistrations(userId: userId)
        return registrations.first { $0.eventId == eventId && $0.status != .cancelled }
    }
}
