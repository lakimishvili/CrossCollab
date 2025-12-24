//
//  SignUpViewModel.swift
//  EventHub
//
//  Created by Bacho on 20.12.25.
//

import Combine
import Foundation

@MainActor
final class SignUpViewModel: ObservableObject {
    
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var email: String = ""
    @Published var phoneNumber: String = ""
    @Published var selectedDepartment: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    
    @Published var otpCode: [String] = Array(repeating: "", count: 6)
    @Published var timeRemaining: Int = 0
    @Published var isOTPSent: Bool = false
    
    @Published var isAgreed: Bool = false
    
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var showErrorAlert: Bool = false
    
    private(set) var departments = ["Engineering", "Marketing", "Sales", "HR", "Finance"]
    private var cancellables = Set<AnyCancellable>()
    weak var coordinator: AuthCoordinatorProtocol?
    private weak var appState: AppState?
    
    init(coordinator: AuthCoordinatorProtocol? = nil, appState: AppState? = nil) {
        self.coordinator = coordinator
        self.appState = appState
    }
    
    // MARK: - Navigation
    
    func goSignInPage() {
        coordinator?.navigate(to: .signIn)
    }
    
    // MARK: - OTP Methods
    func sendOTP() {
        guard !phoneNumber.isEmpty else {
            errorMessage = "Phone number is required"
            return
        }
        
        print("Sending OTP to \(phoneNumber)")
        
        otpCode = Array(repeating: "", count: 6)
        timeRemaining = 50
        isOTPSent = true
        
        startTimer()
    }
    
    func resendOTP() {
        sendOTP()
    }
    
    private func startTimer() {
        cancellables.removeAll()
        
        Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }
                if self.timeRemaining > 0 {
                    self.timeRemaining -= 1
                }
            }
            .store(in: &cancellables)
    }
    
    func handleOTPInput(at index: Int, oldValue: String, newValue: String) {
        if newValue.count > 1 {
            otpCode[index] = String(newValue.last!)
        }
    }
    
    // MARK: - Sign Up
    // MARK: - Sign Up
    func validateAndSignUp() {
        // Trim all inputs
        let trimmedFirstName = firstName.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedLastName = lastName.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedPassword = password.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedConfirmPassword = confirmPassword.trimmingCharacters(in: .whitespacesAndNewlines)
        
        errorMessage = nil
        showErrorAlert = false
        
        guard !trimmedFirstName.isEmpty, !trimmedLastName.isEmpty else {
            showError("First and last name required")
            return
        }
        
        guard !trimmedEmail.isEmpty else {
            showError("Email is required")
            return
        }
        
        guard trimmedEmail.contains("@") else {
            showError("Invalid email format")
            return
        }
        
        guard !trimmedPassword.isEmpty else {
            showError("Password is required")
            return
        }
        
        // ✅ PROPER PASSWORD VALIDATION
        guard trimmedPassword.count >= 8 else {
            showError("Password must be at least 8 characters")
            return
        }
        
        // Check for uppercase letter
        guard trimmedPassword.rangeOfCharacter(from: .uppercaseLetters) != nil else {
            showError("Password must contain at least one uppercase letter")
            return
        }
        
        // Check for lowercase letter
        guard trimmedPassword.rangeOfCharacter(from: .lowercaseLetters) != nil else {
            showError("Password must contain at least one lowercase letter")
            return
        }
        
        // Check for number
        guard trimmedPassword.rangeOfCharacter(from: .decimalDigits) != nil else {
            showError("Password must contain at least one number")
            return
        }
        
        guard trimmedPassword == trimmedConfirmPassword else {
            showError("Passwords do not match")
            return
        }
        
        guard isAgreed else {
            showError("Please agree to terms and conditions")
            return
        }
        
        // Use trimmed values
        let fullName = "\(trimmedFirstName) \(trimmedLastName)"
        
        isLoading = true
        
        Task {
            do {
                try await appState?.register(
                    email: trimmedEmail,
                    password: trimmedPassword,
                    fullName: fullName,
                    rememberMe: true
                )
                
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
