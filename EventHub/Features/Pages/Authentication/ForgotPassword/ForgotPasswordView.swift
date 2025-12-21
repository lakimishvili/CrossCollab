//
//  ForgotPasswordView.swift
//  EventHub
//
//  Created by Bacho on 20.12.25.
//

import SwiftUI

import SwiftUI

struct ForgotPasswordView: View {
    
    @Binding var isPresented: Bool
    @StateObject private var viewModel = ForgotPasswordViewModel()
    
    var body: some View {
        VStack(spacing: 40) {
            
            // MARK: - Header
            AuthHeaderView(
                title: "Forgot Password",
                subtitle: "Enter your email and we'll send you a link to reset your password."
            )
            
            // MARK: - Email Field
            VStack(alignment: .leading, spacing: 8) {
                Text("Email")
                    .font(.system(size: 14, weight: .regular))
                
                HStack(spacing: 8) {
                    Image(systemName: "envelope")
                        .foregroundColor(Color("LightGray"))
                        .opacity(0.4)
                    
                    TextField("Enter your email", text: $viewModel.email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                }
                .padding(.horizontal, 12)
                .frame(height: 42)
                .background(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1.5)
                )
            }
            
            // MARK: - Actions
            VStack(spacing: 16) {
                PrimaryButton(title: "Send Reset Link") {
                    viewModel.sendResetLink()
                }
                
                BackActionButton(title: "Back to Sign In") {
                    isPresented = false
                }
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 20)
    }
}

#Preview {
    ForgotPasswordView(isPresented: .constant(true))
}
