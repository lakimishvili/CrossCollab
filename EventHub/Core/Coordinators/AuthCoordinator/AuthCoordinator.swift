//
//  AuthCoordinator.swift
//  EventHub
//
//  Created by Bacho on 21.12.25.
//

import Foundation
import SwiftUI

class AuthCoordinator: ObservableObject, AuthCoordinatorProtocol, AuthViewProtocol {
    
    @Published var path = NavigationPath()
    
    private weak var appState: AppState?
    
    init(appState: AppState?) {
        self.appState = appState
    }
    
    func navigate(to route: AuthRoute) {
        path.append(route)
    }
    
    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }
    
    @MainActor
    func makeSignUpView() -> SignUpView {
        let viewModel = SignUpViewModel(coordinator: self, appState: appState)
        return SignUpView(viewModel: viewModel)
    }
    
    @MainActor
    func makeSignInView() -> SignInView {
        let viewModel = SignInViewModel(coordinator: self, appState: appState)
        return SignInView(viewModel: viewModel)
    }
}
