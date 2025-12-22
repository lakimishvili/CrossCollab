//
//  AuthViewProtocol.swift
//  EventHub
//
//  Created by Bacho on 21.12.25.
//

protocol AuthViewProtocol: AnyObject {
   @MainActor func makeSignUpView() -> SignUpView
   @MainActor func makeSignInView() -> SignInView
}
