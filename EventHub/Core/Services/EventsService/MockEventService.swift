//
//  MockEventService.swift
//  EventHub
//
//  Created by Bacho on 24.12.25.
//


import Foundation

final class MockEventService: EventServiceProtocol {
    
    private let delay: UInt64 = 1_000_000_000 
    
    // MARK: - Mock Event Types
    private let mockEventTypes: [EventType] = [
        EventType(id: 1, name: "Team Building", description: "Build stronger team connections"),
        EventType(id: 2, name: "Sports", description: "Active and healthy activities"),
        EventType(id: 3, name: "Workshop", description: "Learn new skills"),
        EventType(id: 4, name: "Happy Friday", description: "Weekly social events"),
        EventType(id: 5, name: "Cultural", description: "Cultural experiences"),
        EventType(id: 6, name: "Training", description: "Professional development"),
        EventType(id: 7, name: "Social", description: "Networking and fun")
    ]
    
    // MARK: - Mock Events
    private var mockEvents: [EventListItem] = [
        EventListItem(
            id: 101,
            title: "Annual Team Building Summit",
            eventTypeName: "Team Building",
            startDateTime: "2025-12-28T09:00:00Z",  // ← Dec 28
            location: "Grand Conference Hall",
            capacity: 150,
            confirmedCount: 142,
            isFull: false,
            imageUrl: "https://images.unsplash.com/photo-1511578314322-379afb476865?w=800",
            tags: ["team-building", "networking", "outdoor"]
        ),
        EventListItem(
            id: 102,
            title: "Tech Talk: AI in Business Operations",
            eventTypeName: "Workshop",
            startDateTime: "2026-01-05T11:00:00Z",  // ← Jan 5, 2026
            location: "Virtual Meeting",
            capacity: 100,
            confirmedCount: 100,
            isFull: true,
            imageUrl: "https://images.unsplash.com/photo-1485827404703-89b55fcc595e?w=800",
            tags: ["learning", "remote-friendly"]
        ),
        EventListItem(
            id: 103,
            title: "Leadership Workshop",
            eventTypeName: "Training",
            startDateTime: "2025-12-30T14:00:00Z",  // ← Dec 30
            location: "Training Room B",
            capacity: 30,
            confirmedCount: 28,
            isFull: false,
            imageUrl: "https://images.unsplash.com/photo-1552664730-d307ca884978?w=800",
            tags: ["learning", "indoor"]
        ),
        EventListItem(
            id: 104,
            title: "Happy Friday: Game Night",
            eventTypeName: "Happy Friday",
            startDateTime: "2025-12-27T18:00:00Z",  // ← Dec 27
            location: "Recreation Lounge",
            capacity: 50,
            confirmedCount: 50,
            isFull: true,
            imageUrl: "https://images.unsplash.com/photo-1511882150382-421056c89033?w=800",
            tags: ["indoor", "free-food", "family-friendly"]
        ),
        EventListItem(
            id: 105,
            title: "Weekend Hiking Adventure",
            eventTypeName: "Sports",
            startDateTime: "2026-01-11T08:00:00Z",  // ← Jan 11, 2026
            location: "Kazbegi Mountains",
            capacity: 25,
            confirmedCount: 18,
            isFull: false,
            imageUrl: "https://images.unsplash.com/photo-1551632811-561732d1e306?w=800",
            tags: ["outdoor", "wellness"]
        ),
        EventListItem(
            id: 106,
            title: "Cultural Evening: Traditional Dance",
            eventTypeName: "Cultural",
            startDateTime: "2026-01-15T19:00:00Z",  // ← Jan 15, 2026
            location: "Cultural Center",
            capacity: 80,
            confirmedCount: 62,
            isFull: false,
            imageUrl: "https://images.unsplash.com/photo-1533174072545-7a4b6ad7a6c3?w=800",
            tags: ["indoor", "cultural", "free-food"]
        ),
        EventListItem(
            id: 107,
            title: "Office Football Tournament",
            eventTypeName: "Sports",
            startDateTime: "2026-01-18T16:00:00Z",  // ← Jan 18, 2026
            location: "Sports Complex",
            capacity: 40,
            confirmedCount: 35,
            isFull: false,
            imageUrl: "https://images.unsplash.com/photo-1579952363873-27f3bade9f55?w=800",
            tags: ["outdoor", "wellness"]
        ),
        EventListItem(
            id: 108,
            title: "Mindfulness & Meditation Workshop",
            eventTypeName: "Training",
            startDateTime: "2026-01-22T10:00:00Z",  // ← Jan 22, 2026
            location: "Wellness Room",
            capacity: 20,
            confirmedCount: 15,
            isFull: false,
            imageUrl: "https://images.unsplash.com/photo-1506126613408-eca07ce68773?w=800",
            tags: ["wellness", "indoor", "learning"]
        ),
        EventListItem(
            id: 109,
            title: "Annual Hackathon 2025",
            eventTypeName: "Workshop",
            startDateTime: "2026-01-25T09:00:00Z",  // ← Jan 25, 2026
            location: "Innovation Lab",
            capacity: 60,
            confirmedCount: 58,
            isFull: false,
            imageUrl: "https://images.unsplash.com/photo-1504384308090-c894fdcc538d?w=800",
            tags: ["learning", "networking", "indoor"]
        ),
        EventListItem(
            id: 110,
            title: "Wine Tasting Social",
            eventTypeName: "Social",
            startDateTime: "2026-02-01T19:00:00Z",  // ← Feb 1, 2026
            location: "Rooftop Terrace",
            capacity: 35,
            confirmedCount: 32,
            isFull: false,
            imageUrl: "https://images.unsplash.com/photo-1510812431401-41d2bd2722f3?w=800",
            tags: ["indoor", "networking", "free-food"]
        )
    ]
    
    // MARK: - Get Event Types
    func getEventTypes() async throws -> [EventType] {
        try await Task.sleep(nanoseconds: delay)
        return mockEventTypes
    }
    
    // MARK: - Get Events
    func getEvents(filters: EventFilters? = nil) async throws -> [EventListItem] {
        try await Task.sleep(nanoseconds: delay)
        
        var filteredEvents = mockEvents
        
        // Apply filters
        if let filters = filters {
            // Filter by event type
            if let eventTypeId = filters.eventTypeId {
                let eventTypeName = mockEventTypes.first(where: { $0.id == eventTypeId })?.name
                filteredEvents = filteredEvents.filter { $0.eventTypeName == eventTypeName }
            }
            
            // Filter by location
            if let location = filters.location, !location.isEmpty {
                filteredEvents = filteredEvents.filter {
                    $0.location.localizedCaseInsensitiveContains(location)
                }
            }
            
            // Filter by search keyword (title)
            if let keyword = filters.searchKeyword, !keyword.isEmpty {
                filteredEvents = filteredEvents.filter {
                    $0.title.localizedCaseInsensitiveContains(keyword)
                }
            }
            
            // Filter by availability
            if let onlyAvailable = filters.onlyAvailable, onlyAvailable {
                filteredEvents = filteredEvents.filter { !$0.isFull }
            }
        }
        
        // Sort by date (upcoming first)
        filteredEvents.sort { event1, event2 in
            guard let date1 = DateHelper.parseDate(event1.startDateTime),
                  let date2 = DateHelper.parseDate(event2.startDateTime) else {
                return false
            }
            return date1 < date2
        }
        
        return filteredEvents
    }
    
    // MARK: - Get Event Details
    func getEventDetails(id: Int) async throws -> EventDetails {
        try await Task.sleep(nanoseconds: delay)
        
        // Find event
        guard let event = mockEvents.first(where: { $0.id == id }) else {
            throw NetworkError.serverError(404)
        }
        
        // Create detailed version
        return EventDetails(
            id: event.id,
            title: event.title,
            description: generateDescription(for: event.title),
            eventTypeName: event.eventTypeName,
            startDateTime: event.startDateTime,
            endDateTime: generateEndDateTime(from: event.startDateTime),
            location: event.location,
            capacity: event.capacity,
            confirmedCount: event.confirmedCount,
            waitlistedCount: event.isFull ? 4 : 0,
            isFull: event.isFull,
            tags: event.tags,
            createdBy: "HR Team",
            imageUrl: event.imageUrl
        )
    }
    
    // MARK: - Get User Registrations
    func getUserRegistrations(userId: Int) async throws -> [UserRegistration] {
        try await Task.sleep(nanoseconds: delay)
        
        // Mock: return first 3 upcoming events as registered
        let upcomingEvents = mockEvents
            .filter { DateHelper.isUpcoming($0.startDateTime) }
            .prefix(3)
        
        return upcomingEvents.enumerated().map { index, event in
            UserRegistration(
                registrationId: 1000 + index,
                eventId: event.id,
                eventTitle: event.title,
                eventType: event.eventTypeName,
                startDateTime: event.startDateTime,
                location: event.location,
                status: index == 2 ? .waitlisted : .confirmed,
                registeredAt: "2025-01-15T10:30:00Z"
            )
        }
    }
    
    // MARK: - Register for Event
    func registerForEvent(eventId: Int, userId: Int) async throws -> EventRegistration {
        try await Task.sleep(nanoseconds: delay)
        
        guard let event = mockEvents.first(where: { $0.id == eventId }) else {
            throw NetworkError.serverError(404)
        }
        
        // Determine status based on capacity
        let status: RegistrationStatus = event.isFull ? .waitlisted : .confirmed
        let position = event.isFull ? (event.confirmedCount - event.capacity + 1) : nil
        
        return EventRegistration(
            id: Int.random(in: 1000...9999),
            eventId: eventId,
            userId: userId,
            status: status,
            registeredAt: ISO8601DateFormatter().string(from: Date()),
            position: position
        )
    }
    
    // MARK: - Cancel Registration
    func cancelRegistration(registrationId: Int) async throws {
        try await Task.sleep(nanoseconds: delay)
        // Success - 204 No Content
    }
    
    // MARK: - Helper Methods
    
    private func generateDescription(for title: String) -> String {
        let descriptions = [
            "Join us for an exciting event that brings together team members from across the company. This is a great opportunity to network, learn, and have fun!",
            "Don't miss this amazing opportunity to connect with colleagues and participate in engaging activities designed to foster collaboration and team spirit.",
            "Experience a memorable event filled with interactive sessions, workshops, and networking opportunities. Perfect for all skill levels and interests.",
            "Be part of something special! This event offers unique experiences and valuable insights that will benefit your professional and personal growth."
        ]
        return descriptions.randomElement() ?? descriptions[0]
    }
    
    private func generateEndDateTime(from startDateTime: String) -> String {
        guard let startDate = DateHelper.parseDate(startDateTime) else {
            return startDateTime
        }
        
        // Add 2-4 hours
        let endDate = startDate.addingTimeInterval(TimeInterval(7200 + Int.random(in: 0...7200)))
        return ISO8601DateFormatter().string(from: endDate)
    }
}
