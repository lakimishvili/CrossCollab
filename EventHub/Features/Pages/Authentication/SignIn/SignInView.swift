//
//  SignInView.swift
//  EventHub
//
//  Created by Bacho on 20.12.25.
//

import SwiftUI

struct SignInView: View {
    
    @State private var email = ""
    @State private var password = ""
    @State private var rememberMe = false
    @State private var showForgotPassword = false
    
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()
            
            VStack(spacing: 40) {
                
                // MARK: - Title
                VStack(spacing: 20) {
                    Text("Sign In")
                        .font(.system(size: 36, weight: .regular))
                    
                    Text("Enter your credentials to access your account")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundStyle(Color("LightGray"))
                }
                
                // MARK: - Text Fields
                VStack(spacing: 20) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Email")
                            .font(.system(size: 14, weight: .regular))
                        
                        TextField("Enter your email", text: $email)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .padding(.horizontal, 12)
                            .frame(height: 42)
                            .background(Color.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1.5)
                            )
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Password")
                            .font(.system(size: 14, weight: .regular))
                        
                        SecureField("Enter your password", text: $password)
                            .padding(.horizontal, 12)
                            .frame(height: 42)
                            .background(Color.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1.5)
                            )
                    }
                }
                
                // MARK: - Remember me + Forgot Password
                HStack {
                    Button {
                        rememberMe.toggle()
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: rememberMe ? "checkmark.square.fill" : "square")
                                .foregroundColor(rememberMe ? .black : .gray)
                            
                            Text("Remember me")
                                .font(.system(size: 14))
                                .foregroundColor(.black.opacity(0.7))
                        }
                    }
                    .buttonStyle(.plain)
                    
                    Spacer()
                    
                    Button {
                        withAnimation {
                            showForgotPassword = true
                        }
                    } label: {
                        Text("Forgot password?")
                            .font(.system(size: 14))
                            .foregroundColor(.black)
                    }
                    .buttonStyle(.plain)
                }
                
                // MARK: - Sign In & Sign Up
                VStack(spacing: 16) {
                    Button {
                        print("Sign In tapped")
                    } label: {
                        Text("Sign In")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 48)
                            .background(Color("DarkBlack"))
                            .cornerRadius(8)
                    }
                    
                    HStack(spacing: 4) {
                        Text("Don’t have an account?")
                            .font(.system(size: 14))
                            .foregroundColor(Color("LightGray"))
                        
                        Button {
                            print("Sign in tapped")
                        } label: {
                            Text("Sign up")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(Color("DarkBlack"))
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .padding(.horizontal, 40)
            
            // MARK: - Custom modal overlay
            if showForgotPassword {
                ZStack {
                    Color.black.opacity(0.5)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation { showForgotPassword = false }
                        }
                    
                    ForgotPasswordView(isPresented: $showForgotPassword)
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
}

#Preview {
    SignInView()
}
