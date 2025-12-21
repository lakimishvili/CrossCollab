//
//  SignInViewModel.swift
//  EventHub
//
//  Created by LILIANA on 12/21/25.
//

import Combine
import Foundation

final class SignInViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var rememberMe: Bool = false
    @Published var showForgotPassword: Bool = false
    
    weak var coordinator: AuthCoordinatorProtocol?
    
    init(coordinator: AuthCoordinatorProtocol? = nil) {
        self.coordinator = coordinator
    }
    
    func toggleRememberMe() {
        rememberMe.toggle()
    }
    
    func signIn() {
        guard !email.isEmpty, !password.isEmpty else {
            print("Email and password required")
            return
        }
        print("Signing in with email: \(email), password: \(password)")
        
        coordinator?.completeAuthentication()
    }
    
    func goSignUp() {
        coordinator?.navigate(to: .signUp)
    }
    
    func showForgotPasswordScreen() {
        showForgotPassword = true
    }
}
