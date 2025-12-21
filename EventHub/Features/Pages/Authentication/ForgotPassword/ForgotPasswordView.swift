//
//  ForgotPasswordView.swift
//  EventHub
//
//  Created by Bacho on 20.12.25.
//

import SwiftUI

struct ForgotPasswordView: View {
    @Binding var isPresented: Bool
    @State private var email = ""
    
    var body: some View {
        VStack(spacing: 40) {
            // MARK: - Title
            VStack(spacing: 20) {
                Text("Forgot Password")
                    .font(.system(size: 36, weight: .regular))
                
                Text("Enter your email and we'll send you a link to reset your password.")
                    .lineLimit(2)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundStyle(Color("LightGray"))
            }
            
            // MARK: - TextFields
            VStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Email")
                        .font(.system(size: 14, weight: .regular))
                    
                    HStack(spacing: 8) {
                        Image(systemName: "envelope")
                            .foregroundColor(Color("LightGray"))
                            .opacity(0.4)
                        
                        TextField("Enter your email", text: $email)
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
            }
            // MARK: Actions
            VStack(spacing: 16) {
                Button {
                    print("Reset link tapped")
                } label: {
                    Text("Send Reset Link")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 48)
                        .background(Color("DarkBlack"))
                        .cornerRadius(8)
                }
                
                Button {
                    isPresented = false
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: "arrow.left")
                        Text("Back to Sign In")
                    }
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(Color("DarkBlack"))
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 20)
    }
}

#Preview {
    ForgotPasswordView(isPresented: .constant(true)) 
}
