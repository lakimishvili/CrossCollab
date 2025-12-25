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
    let location: LocationDto?
    let capacity: Int
    var confirmedCount: Int
    let isFull: Bool
    let imageUrl: String?
    let tags: [String]
    let speakers: [SpeakerDto]
    
    enum CodingKeys: String, CodingKey {
        case id, title, eventTypeName, startDateTime, location, capacity
        case confirmedCount, isFull, imageUrl, tags, speakers
    }
    
    var locationString: String {
        guard let loc = location else { return "TBA" }
        
        if let venueName = loc.venueName {
            return venueName
        } else if let city = loc.city {
            return city
        } else {
            return "TBA"
        }
    }
}

struct LocationDto: Codable {
    let type: Int?
    let venueName: String?
    let streetAddress: String?
    let city: String?
    let roomNumber: String?
    let floor: String?
    let notes: String?
}

struct SpeakerDto: Codable, Identifiable {
    let id: Int
    let name: String
    let title: String?
    let description: String?
}

// MARK: - Event Details
struct EventDetails: Codable, Identifiable {
    let id: Int
    let title: String
    let description: String
    let eventTypeName: String
    let startDateTime: String
    let endDateTime: String
    let location: LocationDto?
    let capacity: Int
    var confirmedCount: Int
    let waitlistedCount: Int
    let isFull: Bool
    let tags: [String]
    let createdBy: String
    let imageUrl: String?
    let speakers: [SpeakerDto]
    
    enum CodingKeys: String, CodingKey {
        case id, title, description, eventTypeName, startDateTime, endDateTime
        case location, capacity, confirmedCount, waitlistedCount, isFull
        case tags, createdBy = "createdByName", imageUrl, speakers
    }
    
    var locationString: String {
        guard let loc = location else { return "TBA" }
        
        return loc.venueName ?? loc.city ?? "TBA"
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
    let location: LocationDto?
    let status: RegistrationStatus
    let registeredAt: String
    
    var id: Int { registrationId }
    
    enum CodingKeys: String, CodingKey {
        case registrationId, eventId, eventTitle, eventType
        case startDateTime, location, status, registeredAt
    }
    
    var locationString: String {
        guard let loc = location else { return "TBA" }
        if let venueName = loc.venueName {
            return venueName
        } else if let city = loc.city {
            return city
        } else {
            return "TBA"
        }
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
