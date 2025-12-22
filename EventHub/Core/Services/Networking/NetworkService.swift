//
//  NetworkService.swift
//  EventHub
//
//  Created by Bacho on 22.12.25.
//

import Foundation

final class NetworkService: NetworkServiceProtocol {
    
    static let shared = NetworkService()
    private init() {}
    
    private let baseURL = "https://your-backend-url.com/api"
    
    // MARK: - Generic Fetch
    private func fetch<T: Decodable>(from endpoint: String, method: String = "GET", body: Data? = nil, token: String? = nil) async throws -> T {
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
    
    // MARK: - Login
    func login(email: String, password: String) async throws -> LoginResponse {
        let body = LoginRequest(email: email, password: password)
        let bodyData = try? JSONEncoder().encode(body)
        
        return try await fetch(from: "/auth/login", method: "POST", body: bodyData)
    }
    
    // MARK: - Register
    func register(email: String, password: String, fullName: String) async throws -> LoginResponse {
        let body = RegisterRequest(email: email, password: password, fullName: fullName)
        let bodyData = try? JSONEncoder().encode(body)
        
        return try await fetch(from: "/auth/register", method: "POST", body: bodyData)
    }
    
    // MARK: - Get Current User
    func getCurrentUser(token: String) async throws -> UserProfileResponse {
        return try await fetch(from: "/auth/me", token: token)
    }
}
