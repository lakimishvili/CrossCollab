//
//  AuthCoordinatorView.swift
//  EventHub
//
//  Created by Bacho on 21.12.25.
//

import SwiftUI

struct AuthCoordinatorView: View {
    @StateObject private var coordinator: AuthCoordinator
    
    init(appState: AppState) {
        _coordinator = StateObject(wrappedValue: AuthCoordinator(appState: appState))
    }
    
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            coordinator.makeSignInView()
                .navigationDestination(for: AuthRoute.self) { route in
                    destinationView(for: route)
                }
        }
    }
    
    @ViewBuilder
    private func destinationView(for route: AuthRoute) -> some View {
        switch route {
        case .signUp:
            coordinator.makeSignUpView()
        case .signIn:
            coordinator.makeSignInView()
        }
    }
}

#Preview {
    AuthCoordinatorView(appState: AppState())
}
