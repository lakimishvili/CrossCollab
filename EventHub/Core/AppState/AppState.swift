//
//  AppState.swift
//  EventHub
//
//  Created by Bacho on 21.12.25.
//

import Foundation

class AppState: ObservableObject {
    @Published var currentFlow: AppFlow = .authentication
    @Published var isLoggedIn: Bool = false
    
    func login() {
        isLoggedIn = true
        currentFlow = .main
    }
    
    func logout() {
        isLoggedIn = false
        currentFlow = .authentication
    }
}
