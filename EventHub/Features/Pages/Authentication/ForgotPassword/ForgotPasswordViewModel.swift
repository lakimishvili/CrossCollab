//
//  ForgotPasswordViewModel.swift
//  EventHub
//
//  Created by LILIANA on 12/21/25.
//

import Combine
import Foundation

final class ForgotPasswordViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var isSubmitted: Bool = false
    weak var coordinator: AuthCoordinatorProtocol?
    
    init(coordinator: AuthCoordinatorProtocol? = nil) {
        self.coordinator = coordinator
    }
    
    func sendResetLink() {
        guard !email.isEmpty else {
            print("Email is required")
            return
        }
        print("Sending reset link to \(email)")
        isSubmitted = true
    }
    
    func backToSignIn() {
        coordinator?.navigate(to: .signIn)
    }
}
