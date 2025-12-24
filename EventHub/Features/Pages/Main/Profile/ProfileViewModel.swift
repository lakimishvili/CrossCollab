//
//  ProfileViewModel.swift
//  EventHub
//
//  Created by Bacho on 22.12.25.
//

import Combine

@MainActor
final class ProfileViewModel: ObservableObject {
    
    weak var coordinator: MainCoordinatorProtocol?
    
    @Published var currentUserName: String?
    @Published var currentUserEmail: String?
    
    init(coordinator: MainCoordinatorProtocol? = nil) {
        self.coordinator = coordinator
        loadUser()
    }
    
    func logout() {
        coordinator?.logout()
    }
    
    func loadUser() {
        let auth = AuthService.shared
        currentUserName = auth.currentUserName
        currentUserEmail = auth.currentUserId != nil ? "user\(auth.currentUserId!)@example.com" : nil
    }
}
