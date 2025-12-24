//
//  AppState.swift
//  EventHub
//
//  Created by Bacho on 21.12.25.
//

import Foundation

@MainActor
final class AppState: ObservableObject {
    
    @Published var currentFlow: AppFlow
    private let authService: AuthService
    
    // MARK: - User Info
    @Published var currentUserId: Int?
    @Published var currentUserRole: String?
    @Published var currentUserName: String?
    
    // MARK: - Init
    init(authService: AuthService = AuthService.shared) {
        self.authService = authService
        
        if authService.isLoggedIn {
            self.currentFlow = .main
            self.currentUserId = authService.currentUserId
            self.currentUserRole = authService.currentUserRole
            self.currentUserName = authService.currentUserName
        } else {
            self.currentFlow = .authentication
        }
    }
    
    // MARK: - Login
    func login(email: String, password: String, rememberMe: Bool = true) async throws {
        let response = try await authService.login(
            email: email,
            password: password,
            rememberMe: rememberMe 
        )
        
        self.currentUserId = response.userId
        self.currentUserRole = response.role
        self.currentUserName = response.fullName
        self.currentFlow = .main
    }
    
    // MARK: - Register
    func register(email: String, password: String, fullName: String, rememberMe: Bool = true) async throws {
        let response = try await authService.register(
            email: email,
            password: password,
            fullName: fullName,
            rememberMe: rememberMe
        )
        
        self.currentUserId = response.userId
        self.currentUserRole = response.role
        self.currentUserName = response.fullName
        self.currentFlow = .main
    }
    
    // MARK: - Logout
    func logout() {
        authService.logout()
        
        self.currentUserId = nil
        self.currentUserRole = nil
        self.currentUserName = nil
        self.currentFlow = .authentication
    }
    
    // MARK: - Get Current User (for refreshing profile)
    func refreshCurrentUser() async throws {
        let userProfile = try await authService.getCurrentUser()
        
        self.currentUserId = userProfile.id
        self.currentUserRole = userProfile.role
        self.currentUserName = userProfile.fullName
    }
}
