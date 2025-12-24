//
//  EventServiceProtocol.swift
//  EventHub
//
//  Created by Bacho on 23.12.25.
//

import Foundation

protocol EventServiceProtocol {
    
    func getEventTypes() async throws -> [EventType]
    func getEvents(filters: EventFilters?) async throws -> [EventListItem]
    func getEventDetails(id: Int) async throws -> EventDetails
    func getUserRegistrations(userId: Int) async throws -> [UserRegistration]
    func registerForEvent(eventId: Int, userId: Int) async throws -> EventRegistration
    func cancelRegistration(registrationId: Int) async throws
}
