//
//  SignInView.swift
//  EventHub
//
//  Created by Bacho on 20.12.25.
//

import SwiftUI

import SwiftUI

struct SignInView: View {
    @StateObject private var viewModel = SignInViewModel()
    
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()
            
            VStack(spacing: 40) {
                
                // MARK: - Header
                AuthHeaderView(
                    title: "Sign In",
                    subtitle: "Enter your credentials to access your account"
                )
                
                // MARK: - Text Fields
                VStack(spacing: 20) {
                    CustomTextField(
                        title: "Email",
                        placeholder: "Enter your email",
                        text: $viewModel.email
                    )
                    .keyboardType(.emailAddress)
                    
                    CustomTextField(
                        title: "Password",
                        placeholder: "Enter your password",
                        text: $viewModel.password,
                        isPassword: true
                    )
                }
                
                // MARK: - Remember Me & Forgot Password
                HStack {
                    rememberMeButton
                    Spacer()
                    forgotPasswordButton
                }
                
                // MARK: - Actions
                VStack(spacing: 16) {
                    PrimaryButton(title: "Sign In") {
                        viewModel.signIn()
                    }
                    
                    SignInPrompt(
                        lhs: "Don’t have an account?",
                        rhs: "Sign up"
                    ) {
                        viewModel.goSignUp()
                    }
                }
            }
            .padding(.horizontal, 40)
            
            // MARK: - Forgot Password Overlay
            forgotPasswordOverlay
        }
    }
}

// MARK: - Private Components
private extension SignInView {
    
    var rememberMeButton: some View {
        Button {
            viewModel.toggleRememberMe()
        } label: {
            HStack(spacing: 8) {
                Image(systemName: viewModel.rememberMe ? "checkmark.square.fill" : "square")
                    .foregroundColor(viewModel.rememberMe ? .black : .gray)
                Text("Remember me")
                    .font(.system(size: 14))
                    .foregroundColor(.black.opacity(0.7))
            }
        }
        .buttonStyle(.plain)
    }
    
    var forgotPasswordButton: some View {
        Button {
            withAnimation {
                viewModel.showForgotPasswordScreen()
            }
        } label: {
            Text("Forgot password?")
                .font(.system(size: 14))
                .foregroundColor(.black)
        }
        .buttonStyle(.plain)
    }
    
    @ViewBuilder
    var forgotPasswordOverlay: some View {
        if viewModel.showForgotPassword {
            ZStack {
                Color.black.opacity(0.5)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation { viewModel.showForgotPassword = false }
                    }
                
                ForgotPasswordView(isPresented: $viewModel.showForgotPassword)
                    .padding(24)
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
                    .padding(.horizontal, 10)
                    .frame(maxHeight: 500)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .transition(.opacity.combined(with: .move(edge: .bottom)))
        }
    }
}

#Preview {
    SignInView()
}
