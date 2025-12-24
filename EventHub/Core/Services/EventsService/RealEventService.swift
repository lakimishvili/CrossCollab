//
//  RealEventService.swift
//  EventHub
//
//  Created by Bacho on 23.12.25.
//

import Foundation

final class RealEventService: EventServiceProtocol {
    
    static let shared = RealEventService()
    private init() {}
    
    private let baseURL = "http://54.93.219.66:8080/api"
    
    // MARK: - Get Event Types
    func getEventTypes() async throws -> [EventType] {
        let dto: [EventTypeDto] = try await fetch(from: "/Events/types")
        
        return dto.map { EventType(id: $0.id, name: $0.name, description: $0.description) }
    }

    // MARK: - Get Events
    func getEvents(filters: EventFilters? = nil) async throws -> [EventListItem] {
        var endpoint = "/Events"
        
        if let filters = filters {
            let queryParams = filters.queryParams
            if !queryParams.isEmpty {
                let queryString = queryParams
                    .map { "\($0.key)=\($0.value)" }
                    .joined(separator: "&")
                endpoint += "?\(queryString)"
            }
        }
        
        return try await fetch(from: endpoint)
    }
    
    // MARK: - Get Event Details
    func getEventDetails(id: Int) async throws -> EventDetails {
        let dto: EventDetailsDto = try await fetch(from: "/Events/\(id)")
        
        return EventDetails(
            id: dto.id,
            title: dto.title,
            description: dto.description,
            eventTypeName: dto.eventTypeName,
            startDateTime: dto.startDateTime,
            endDateTime: dto.endDateTime,
            location: dto.location,
            capacity: dto.capacity,
            confirmedCount: dto.confirmedCount,
            waitlistedCount: dto.waitlistedCount,
            isFull: dto.isFull,
            tags: dto.tags,
            createdBy: dto.createdByName,
            imageUrl: dto.imageUrl
        )
    }
    
    // MARK: - Get User Registrations
    func getUserRegistrations(userId: Int) async throws -> [UserRegistration] {
        return try await fetch(from: "/Registrations/user/\(userId)", token: getToken())
    }
    
    // MARK: - Register for Event
    func registerForEvent(eventId: Int, userId: Int) async throws -> EventRegistration {
        let body = RegistrationRequest(eventId: eventId, userId: userId)
        let bodyData = try? JSONEncoder().encode(body)
        
        let dto: RegistrationDto = try await fetch(
            from: "/Registrations",
            method: "POST",
            body: bodyData,
            token: getToken()
        )
        
        return EventRegistration(
            id: dto.id,
            eventId: dto.eventId,
            userId: dto.userId,
            status: RegistrationStatus(rawValue: dto.status) ?? .confirmed,
            registeredAt: dto.registeredAt,
            position: dto.waitlistPosition
        )
    }
    
    // MARK: - Cancel Registration
    func cancelRegistration(registrationId: Int) async throws {
        guard let userId = KeychainManager.shared.currentUserId else {
            throw NetworkError.unauthorized
        }
        
        let _: EmptyResponse = try await fetch(
            from: "/Registrations/\(registrationId)?userId=\(userId)",
            method: "DELETE",
            token: getToken()
        )
    }
    
    // MARK: - Generic Fetch
    private func fetch<T: Decodable>(
        from endpoint: String,
        method: String = "GET",
        body: Data? = nil,
        token: String? = nil
    ) async throws -> T {
        guard let url = URL(string: "\(baseURL)\(endpoint)") else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let token = token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        if let body = body {
            request.httpBody = body
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        if httpResponse.statusCode == 204 {
            return EmptyResponse() as! T
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            if httpResponse.statusCode == 401 {
                throw NetworkError.unauthorized
            }
            throw NetworkError.serverError(httpResponse.statusCode)
        }
        
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingFailed
        }
    }
    
    // MARK: - Helper: Get Token from Keychain
    private func getToken() -> String? {
        return KeychainManager.shared.loadToken()
    }
}

// MARK: - Empty Response (for DELETE endpoints)
struct EmptyResponse: Codable {}

// MARK: - DTOs that match backend exactly
struct EventDetailsDto: Codable {
    let id: Int
    let title: String
    let description: String
    let eventTypeName: String
    let startDateTime: String
    let endDateTime: String
    let location: String
    let capacity: Int
    let imageUrl: String?
    let confirmedCount: Int
    let waitlistedCount: Int
    let isFull: Bool
    let tags: [String]
    let createdByName: String
}

struct RegistrationDto: Codable {
    let id: Int
    let eventId: Int
    let userId: Int
    let status: String
    let registeredAt: String
    let waitlistPosition: Int?
}

struct EventTypeDto: Codable {
    let id: Int
    let name: String
    let description: String?
    let isActive: Bool
}
