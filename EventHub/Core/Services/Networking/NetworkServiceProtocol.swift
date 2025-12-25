//
//  NetworkServiceProtocol.swift
//  EventHub
//
//  Created by Bacho on 22.12.25.
//

import Foundation

protocol NetworkServiceProtocol {
    func login(email: String, password: String) async throws -> LoginResponse
    func register(email: String, password: String, fullName: String) async throws -> LoginResponse
    func getCurrentUser(token: String) async throws -> UserProfileResponse
    func sendVerificationCode(phoneNumber: String) async throws
    func verifyPhone(phoneNumber: String, code: String) async throws
}
