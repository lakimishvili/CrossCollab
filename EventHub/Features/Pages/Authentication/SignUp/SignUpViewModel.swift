//
//  SignUpViewModel.swift
//  EventHub
//
//  Created by Bacho on 20.12.25.
//

import Combine
import Foundation

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
    
    private(set) var departments = ["Engineering", "Marketing", "Sales", "HR", "Finance"]
    private var cancellables = Set<AnyCancellable>()
    weak var coordinator: AuthCoordinatorProtocol?
    
    init(coordinator: AuthCoordinatorProtocol? = nil) {
        self.coordinator = coordinator
    }
    
    // MARK: - Navigation
    
    func goSignInPage() {
        coordinator?.navigate(to: .signIn)
    }
    
    // MARK: - OTP Methods
    func sendOTP() {
        guard !phoneNumber.isEmpty else {
            print("Phone number is required")
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
    
    // MARK: - Validation
    func validateAndSignUp() {
        guard !firstName.isEmpty,
              !lastName.isEmpty,
              !email.isEmpty,
              !phoneNumber.isEmpty,
              !selectedDepartment.isEmpty else {
            print("All fields are required")
            return
        }
        
        let otp = otpCode.joined()
        guard otp.count == 6 else {
            print("OTP is required")
            return
        }
        
        print("Sign up successful!")
        print("Name: \(firstName) \(lastName)")
        print("Email: \(email)")
        print("Phone: \(phoneNumber)")
        print("Department: \(selectedDepartment)")
        print("OTP: \(otp)")
    }
}
