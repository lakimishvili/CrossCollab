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
    
    private let baseURL = "http://54.93.219.66:8080/api"
    
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
        
        // ✅ Print full request details
        print("🌐 REQUEST: \(method) \(url)")
        print("📋 HEADERS: \(request.allHTTPHeaderFields ?? [:])")
        if let bodyData = body, let bodyString = String(data: bodyData, encoding: .utf8) {
            print("📤 BODY: \(bodyString)")
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        print("📥 RESPONSE STATUS: \(httpResponse.statusCode)")
        
        if let responseString = String(data: data, encoding: .utf8) {
            print("📥 RESPONSE BODY: \(responseString)")
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
            print("❌ DECODE ERROR: \(error)")
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
    func register(
        email: String,
        phoneNumber: String,
        otpCode: String,
        password: String,
        fullName: String
    ) async throws -> LoginResponse {
        let body = RegisterRequest(
            email: email,
            phoneNumber: phoneNumber,
            otpCode: otpCode,
            password: password,
            fullName: fullName
        )
        let bodyData = try JSONEncoder().encode(body)
        
        if let jsonString = String(data: bodyData, encoding: .utf8) {
            print("📤 SENDING REGISTRATION:")
            print(jsonString)
        }
        
        return try await fetch(from: "/Auth/register", method: "POST", body: bodyData)
    }

    
    // MARK: - Get Current User
    func getCurrentUser(token: String) async throws -> UserProfileResponse {
        return try await fetch(from: "/auth/me", token: token)
    }
    
    // MARK: - Send OTP
    func sendRegistrationOtp(email: String, phoneNumber: String) async throws {
        let body = SendRegistrationOtpRequest(email: email, phoneNumber: phoneNumber)
        let bodyData = try JSONEncoder().encode(body)
        
        if let jsonString = String(data: bodyData, encoding: .utf8) {
            print("📤 SENDING REGISTRATION OTP:")
            print(jsonString)
        }
        
        let _: [String: String] = try await fetch(
            from: "/Auth/send-registration-otp",
            method: "POST",
            body: bodyData
        )
    }
    
    // MARK: - Verify OTP (NEW ENDPOINT)
    func verifyPhone(phoneNumber: String, code: String) async throws {
        let body = ["phoneNumber": phoneNumber, "code": code]
        let bodyData = try JSONEncoder().encode(body)
        
        let response: [String: String] = try await fetch(
            from: "/Verification/verify-code",
            method: "POST",
            body: bodyData
        )
        
        print("✅ Verify Response: \(response)")
    }
}

struct EmptyOTPResponse: Codable {}
