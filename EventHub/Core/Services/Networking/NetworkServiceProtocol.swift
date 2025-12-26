//
//  NetworkServiceProtocol.swift
//  EventHub
//
//  Created by Bacho on 22.12.25.
//

import Foundation

protocol NetworkServiceProtocol {
    func login(email: String, password: String) async throws -> LoginResponse
    func sendRegistrationOtp(email: String, phoneNumber: String) async throws
    func register(email: String, phoneNumber: String, otpCode: String, password: String, fullName: String) async throws -> LoginResponse
    func getCurrentUser(token: String) async throws -> UserProfileResponse
}
