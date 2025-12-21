//
//  SignUpView.swift
//  EventHub
//
//  Created by Bacho on 20.12.25.
//

import SwiftUI

struct SignUpView: View {
    
    @StateObject var viewModel: SignUpViewModel
    
    var body: some View {
        
        ScrollView {
            VStack {
                Text("Create Account")
                    .font(.title)
                
                Text("Enter your details to get started.")
                    .font(.callout)
                    .foregroundStyle(.gray)
                    .padding(.top, 1)
                
                VStack(spacing: 10) {
                    HStack (spacing: 16) {
                        CustomTextField(
                            title: "First Name",
                            placeholder: "John",
                            text: $viewModel.firstName
                        )
                        CustomTextField(
                            title: "Last Name",
                            placeholder: "Doe",
                            text: $viewModel.lastName
                        )
                    }
                    
                    CustomTextField(
                        title: "Email",
                        placeholder: "john.doe@company.com",
                        text: $viewModel.email
                    )
                    
                    NumberInputView(
                        number: $viewModel.phoneNumber,
                        action: viewModel.sendOTP
                    )
                    
                    HStack {
                        Image("shield")
                            .resizable()
                            .frame(width: 14, height: 14)
                        
                        Text("Enter OTP Code")
                        
                        Spacer()
                        
                    }
                    
                    OTPVerificationView(
                        otpCode: $viewModel.otpCode,
                        timeRemaining: $viewModel.timeRemaining,
                        isOTPSent: $viewModel.isOTPSent,
                        onResend: viewModel.resendOTP,
                        onOTPChange: { index, oldValue, newValue in
                            viewModel.handleOTPInput(at: index, oldValue: oldValue, newValue: newValue)
                        }
                    )
                    
                    CustomPicker(
                        title: "Department",
                        placeholder: "Select Department",
                        selection: $viewModel.selectedDepartment,
                        options: viewModel.departments
                    )
                    
                    CustomTextField(
                        title: "Password",
                        placeholder: "Create password",
                        text: $viewModel.password,
                        isPassword: true,
                        helperText: "Password must be at least 8 characters with uppercase, lowercase, and number.",
                        showInfoIcon: true,
                    )
                    
                    CustomTextField(
                        title: "Confirm Password",
                        placeholder: "Confirm password",
                        text: $viewModel.confirmPassword,
                        isPassword: true,
                        helperText: "Passwords must be matched",
                        showInfoIcon: true,
                    )
                    
                    AgreementCheckbox(
                        isAgreed: $viewModel.isAgreed,
                        action: {
                            print("Go to privacy and policy page")
                        }
                    )
                    
                    PrimaryButton(
                        title: "Create Account",
                        action: {
                            viewModel.goSignInPage()
                        }
                    )
                    .padding(.top, 26)
                    
                    SignInPrompt(
                        lhs: "Already have an account?",
                        rhs: "Sign In",
                        action: {
                            viewModel.goSignInPage()
                        }
                    )
                }
                .padding(.horizontal, 35)
                .padding(.top, 20)
                
                Spacer()
            }
            .padding(.top, 20)
            
        }
        .dismissKeyboardOnTap()
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    SignUpView(viewModel: SignUpViewModel())
}
