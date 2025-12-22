//
//  AuthService.swift
//  EventHub
//
//  Created by Bacho on 22.12.25.
//

import Foundation

final class AuthService {
    
    // MARK: - Dependencies
    private let networkService: NetworkServiceProtocol
    private let keychainManager: KeychainManager
    
    // MARK: - Singleton (optional - can use DI instead)
    static let shared = AuthService(
        networkService: MockNetworkService(),
        keychainManager: KeychainManager.shared
    )
    
    // MARK: - Init
    init(networkService: NetworkServiceProtocol, keychainManager: KeychainManager) {
        self.networkService = networkService
        self.keychainManager = keychainManager
    }
    
    // MARK: - Login
    func login(email: String, password: String, rememberMe: Bool = true) async throws -> LoginResponse {
        let response = try await networkService.login(email: email, password: password)
        
        if rememberMe {
            _ = keychainManager.saveToken(response.token)
            _ = keychainManager.saveUserId(response.userId)
            _ = keychainManager.saveUserRole(response.role)
        }
        
        return response
    }
    
    // MARK: - Register
    func register(email: String, password: String, fullName: String, rememberMe: Bool = true) async throws -> LoginResponse {
        let response = try await networkService.register(
            email: email,
            password: password,
            fullName: fullName
        )
        
        if rememberMe {
            _ = keychainManager.saveToken(response.token)
            _ = keychainManager.saveUserId(response.userId)
            _ = keychainManager.saveUserRole(response.role)
        }
        
        return response
    }
    
    // MARK: - Logout
    func logout() {
        _ = keychainManager.clearAll()
    }
    
    // MARK: - Get Current User
    func getCurrentUser() async throws -> UserProfileResponse {
        guard let token = keychainManager.loadToken() else {
            throw NetworkError.unauthorized
        }
        
        return try await networkService.getCurrentUser(token: token)
    }
    
    // MARK: - Check Auth Status
    var isLoggedIn: Bool {
        keychainManager.isLoggedIn
    }
    
    var currentToken: String? {
        keychainManager.loadToken()
    }
    
    var currentUserId: Int? {
        keychainManager.currentUserId
    }
    
    var currentUserRole: String? {
        keychainManager.currentUserRole
    }
}
