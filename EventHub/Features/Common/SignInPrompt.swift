//
//  SignInPrompt.swift
//  EventHub
//
//  Created by Bacho on 21.12.25.
//


import SwiftUI

struct SignInPrompt: View {
    let lhs: String
    let rhs: String
    let action: () -> Void
    
    var body: some View {
        HStack(spacing: 4) {
            Text(lhs)
                .foregroundColor(.gray)
                .font(.callout)
            
            Text(rhs)
                .foregroundColor(.black)
                .font(.callout)
                .onTapGesture {
                    action()
                }
        }
    }
}

