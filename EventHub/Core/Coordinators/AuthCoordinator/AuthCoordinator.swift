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
    
    func completeAuthentication() {
        appState?.login()
    }
    
    func makeSignUpView() -> SignUpView {
        let viewModel = SignUpViewModel(coordinator: self)
        return SignUpView(viewModel: viewModel)
    }
    
    func makeSignInView() -> SignInView {
        let viewModel = SignInViewModel(coordinator: self)
        return SignInView(viewModel: viewModel)
    }
}
