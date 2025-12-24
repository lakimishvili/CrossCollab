//
//  EventListItem.swift
//  EventHub
//
//  Created by Bacho on 24.12.25.
//

import Foundation

// MARK: - Event List Item (for Home/Browse)
struct EventListItem: Codable, Identifiable {
    let id: Int
    let title: String
    let eventTypeName: String
    let startDateTime: String
    let location: String
    let capacity: Int
    let confirmedCount: Int
    let isFull: Bool
    let imageUrl: String?
    let tags: [String]
    
    enum CodingKeys: String, CodingKey {
        case id, title, eventTypeName, startDateTime, location, capacity
        case confirmedCount, isFull, imageUrl, tags
    }
}

// MARK: - Event Details
struct EventDetails: Codable, Identifiable {
    let id: Int
    let title: String
    let description: String
    let eventTypeName: String
    let startDateTime: String
    let endDateTime: String
    let location: String
    let capacity: Int
    let confirmedCount: Int
    let waitlistedCount: Int
    let isFull: Bool
    let tags: [String]
    let createdBy: String
    let imageUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case id, title, description, eventTypeName, startDateTime, endDateTime
        case location, capacity, confirmedCount, waitlistedCount, isFull
        case tags, createdBy, imageUrl
    }
}

// MARK: - Event Type
struct EventType: Codable, Identifiable {
    let id: Int
    let name: String
    let description: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name, description
    }
}

// MARK: - Event Registration
struct EventRegistration: Codable, Identifiable {
    let id: Int
    let eventId: Int
    let userId: Int
    let status: RegistrationStatus
    let registeredAt: String
    let position: Int?
    
    enum CodingKeys: String, CodingKey {
        case id, eventId, userId, status, registeredAt, position
    }
}

// MARK: - Registration Status
enum RegistrationStatus: String, Codable {
    case confirmed = "Confirmed"
    case waitlisted = "Waitlisted"
    case cancelled = "Cancelled"
}

// MARK: - User Registration (for My Events)
struct UserRegistration: Codable, Identifiable {
    let registrationId: Int
    let eventId: Int
    let eventTitle: String
    let eventType: String
    let startDateTime: String
    let location: String
    let status: RegistrationStatus
    let registeredAt: String
    
    var id: Int { registrationId }
    
    enum CodingKeys: String, CodingKey {
        case registrationId, eventId, eventTitle, eventType
        case startDateTime, location, status, registeredAt
    }
}

// MARK: - Registration Request
struct RegistrationRequest: Codable {
    let eventId: Int
    let userId: Int
    
    enum CodingKeys: String, CodingKey {
        case eventId, userId
    }
}
