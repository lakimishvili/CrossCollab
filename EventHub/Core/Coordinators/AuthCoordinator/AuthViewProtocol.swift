//
//  AuthViewProtocol.swift
//  EventHub
//
//  Created by Bacho on 21.12.25.
//

protocol AuthViewProtocol: AnyObject {
    func makeSignUpView() -> SignUpView
    func makeSignInView() -> SignInView
}
