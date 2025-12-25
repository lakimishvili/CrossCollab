//
//  SignInViewModel.swift
//  EventHub
//
//  Created by LILIANA on 12/21/25.
//

import Combine
import Foundation

@MainActor
final class SignInViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var rememberMe: Bool = false
    @Published var showForgotPassword: Bool = false
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var showErrorAlert: Bool = false
    
    weak var coordinator: AuthCoordinatorProtocol?
    private weak var appState: AppState?
    
    init(coordinator: AuthCoordinatorProtocol? = nil, appState: AppState? = nil) {
        self.coordinator = coordinator
        self.appState = appState
    }
    
    func toggleRememberMe() {
        rememberMe.toggle()
    }
    
    func signIn() async {
        errorMessage = nil
        showErrorAlert = false
        
        guard !email.isEmpty, !password.isEmpty else {
            showError("Email and password required")
            return
        }
        
        isLoading = true
        
        do {
            try await appState?.login(email: email, password: password, rememberMe: rememberMe)
            
            await MainActor.run {
                isLoading = false
            }
            
        } catch let error as NetworkError {
            await MainActor.run {
                isLoading = false
                showError(error.localizedDescription)
            }
        } catch {
            await MainActor.run {
                isLoading = false
                showError("An unexpected error occurred")
            }
        }
    }
    
    func goSignUp() {
        coordinator?.navigate(to: .signUp)
    }
    
    func showForgotPasswordScreen() {
        showForgotPassword = true
    }
    
    private func showError(_ message: String) {
        errorMessage = message
        showErrorAlert = true
    }
    
    func dismissError() {
        errorMessage = nil
        showErrorAlert = false
    }
}
