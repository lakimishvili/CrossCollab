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
    weak var appState: AppState?
    
    // MARK: - Get Event Types
    func getEventTypes() async throws -> [EventType] {
        print("🌐 Calling /Events/types endpoint...")
        
        do {
            // ✅ Backend returns array of EventType objects
            let types: [EventType] = try await fetch(
                from: "/Events/types",
                token: await getToken()
            )
            
            print("✅ Fetched \(types.count) event types: \(types.map { $0.name })")
            return types
            
        } catch {
            print("❌ getEventTypes error: \(error)")
            throw error
        }
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
        
        let response: [String: Any] = try await fetchJSON(from: endpoint)
        guard let dataArray = response["data"] as? [[String: Any]] else {
            throw NetworkError.decodingFailed
        }
        
        let jsonData = try JSONSerialization.data(withJSONObject: dataArray)
        return try JSONDecoder().decode([EventListItem].self, from: jsonData)
    }
    
    // MARK: - Get Event Details
    func getEventDetails(id: Int) async throws -> EventDetails {
        
        let events = try await getEvents()
        guard let listItem = events.first(where: { $0.id == id }) else {
            throw NetworkError.decodingFailed
        }
        
        let dto: EventDetailsDto = try await fetch(from: "/Events/\(id)")
        
        return EventDetails(
            id: dto.id,
            title: dto.title,
            description: dto.description,
            eventTypeName: dto.eventTypeName,
            startDateTime: dto.startDateTime,
            endDateTime: dto.endDateTime,
            location: listItem.location, 
            capacity: dto.capacity,
            confirmedCount: dto.confirmedCount,
            waitlistedCount: dto.waitlistedCount,
            isFull: dto.isFull,
            tags: dto.tags,
            createdBy: dto.createdByName,
            imageUrl: dto.imageUrl,
            speakers: dto.speakers
        )
    }
    
    // MARK: - Get User Registrations
    func getUserRegistrations(userId: Int) async throws -> [UserRegistration] {
        return try await fetch(from: "/Registrations/user/\(userId)", token: await getToken())
    }
    
    // MARK: - Register for Event
    func registerForEvent(eventId: Int, userId: Int) async throws -> EventRegistration {
        let body = RegistrationRequest(eventId: eventId, userId: userId)
        let bodyData = try JSONEncoder().encode(body)
        
        let dto: RegistrationDto = try await fetch(
            from: "/Registrations",
            method: "POST",
            body: bodyData,
            token: await getToken()
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
        guard let userId = await appState?.currentUserId else {
            throw NetworkError.unauthorized
        }
        
        let _: EmptyResponse = try await fetch(
            from: "/Registrations/\(registrationId)?userId=\(userId)",
            method: "DELETE",
            token: await getToken()
        )
    }
}

// MARK: - Private Methods
private extension RealEventService {
    
    func fetchJSON(from endpoint: String) async throws -> [String: Any] {
        guard let url = URL(string: "\(baseURL)\(endpoint)") else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let token = await getToken() {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.serverError(httpResponse.statusCode)
        }
        
        guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            throw NetworkError.decodingFailed
        }
        
        return json
    }
    
    func fetch<T: Decodable>(
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
        
        return try JSONDecoder().decode(T.self, from: data)
    }
    
    func getToken() async -> String? {
        await MainActor.run {
            if let sessionToken = appState?.sessionToken {
                return sessionToken
            }
            return KeychainManager.shared.loadToken()
        }
    }
}

// MARK: - DTOs
struct EmptyResponse: Codable {}

struct EventDetailsDto: Codable {
    let id: Int
    let title: String
    let description: String
    let eventTypeName: String
    let startDateTime: String
    let endDateTime: String
    let location: LocationDto?
    let capacity: Int
    let imageUrl: String?
    let confirmedCount: Int
    let waitlistedCount: Int
    let isFull: Bool
    let tags: [String]
    let createdByName: String
    let speakers: [SpeakerDto]
}

struct RegistrationDto: Codable {
    let id: Int
    let eventId: Int
    let userId: Int
    let status: String
    let registeredAt: String
    let waitlistPosition: Int?
}
