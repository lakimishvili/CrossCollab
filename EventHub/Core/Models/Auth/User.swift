//
//  User.swift
//  EventHub
//
//  Created by Bacho on 22.12.25.
//


import Foundation

// MARK: - User Model
struct User: Codable, Identifiable {
    let id: Int
    let email: String
    let fullName: String
    let roleId: Int
    let roleName: String
    let isActive: Bool
    let createdAt: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case email
        case fullName
        case roleId
        case roleName
        case isActive
        case createdAt
    }
}

// MARK: - Login Response
struct LoginResponse: Codable {
    let token: String
    let userId: Int
    let fullName: String
    let role: String
    let expiresAt: String
    
    enum CodingKeys: String, CodingKey {
        case token
        case userId
        case fullName
        case role
        case expiresAt
    }
}

// MARK: - Send Registration OTP Request
struct SendRegistrationOtpRequest: Codable {
    let email: String
    let phoneNumber: String
}

// MARK: - Register Request (UPDATED!)
struct RegisterRequest: Codable {
    let email: String
    let phoneNumber: String
    let otpCode: String     
    let password: String
    let fullName: String
}

// MARK: - Login Request
struct LoginRequest: Codable {
    let email: String
    let password: String
    
    enum CodingKeys: String, CodingKey {
        case email
        case password
    }
}

// MARK: - User Profile Response (from /api/auth/me)
struct UserProfileResponse: Codable {
    let id: Int
    let email: String
    let fullName: String
    let role: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case email
        case fullName
        case role
    }
}

// MARK: - Error Response
struct ErrorResponse: Codable {
    let message: String
    let errorCode: String?
    let statusCode: Int?
    let timestamp: String?
    let details: [String: [String]]?
    
    enum CodingKeys: String, CodingKey {
        case message
        case errorCode
        case statusCode
        case timestamp
        case details
    }
}
