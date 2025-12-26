//
//  MockNetworkService.swift
//  EventHub
//
//  Created by Bacho on 22.12.25.
//

import Foundation

final class MockNetworkService: NetworkServiceProtocol {
    
    private let delay: UInt64 = 1_000_000_000 
    
    private var mockUsers: [String: (password: String, user: LoginResponse)] = [
        "test@test.com": (
            password: "123",
            user: LoginResponse(
                token: "mock_jwt_token_12345",
                userId: 1,
                fullName: "Test User",
                role: "Employee",
                expiresAt: "2025-12-23T10:00:00Z"
            )
        )
    ]
    
    func login(email: String, password: String) async throws -> LoginResponse {
        try await Task.sleep(nanoseconds: delay)
        
        guard let mockUser = mockUsers[email] else {
            throw NetworkError.serverError(404)
        }
        
        guard mockUser.password == password else {
            throw NetworkError.serverError(401)
        }
        
        return mockUser.user
    }
    
    func getCurrentUser(token: String) async throws -> UserProfileResponse {
        try await Task.sleep(nanoseconds: delay)
        
        guard let user = mockUsers.values.first(where: { $0.user.token == token }) else {
            throw NetworkError.unauthorized
        }
        
        return UserProfileResponse(
            id: user.user.userId,
            email: mockUsers.first(where: { $0.value.user.token == token })?.key ?? "",
            fullName: user.user.fullName,
            role: user.user.role
        )
    }
    
    func sendRegistrationOtp(email: String, phoneNumber: String) async throws {
        try await Task.sleep(nanoseconds: delay)
        print("📱 Mock Registration OTP sent to \(phoneNumber) for \(email): 123456")
    }
    
    func register(
        email: String,
        phoneNumber: String,
        otpCode: String,
        password: String,
        fullName: String
    ) async throws -> LoginResponse {
        try await Task.sleep(nanoseconds: delay)
        
        // Mock: Accept "123456" as valid OTP
        guard otpCode == "123456" else {
            throw NetworkError.serverError(400)
        }
        
        if mockUsers[email] != nil {
            throw NetworkError.serverError(409)
        }
        
        let newUser = LoginResponse(
            token: "mock_jwt_token_\(UUID().uuidString)",
            userId: mockUsers.count + 1,
            fullName: fullName,
            role: "Employee",
            expiresAt: "2025-12-23T10:00:00Z"
        )
        
        mockUsers[email] = (password: password, user: newUser)
        
        return newUser
    }
}
