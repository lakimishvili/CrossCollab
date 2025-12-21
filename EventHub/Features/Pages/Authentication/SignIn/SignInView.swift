//
//  SignInView.swift
//  EventHub
//
//  Created by Bacho on 20.12.25.
//

import SwiftUI

struct SignInView: View {
    var body: some View {
        VStack {
            Image(systemName: "person.circle")
                .resizable()
                .frame(width: 100, height: 100)
                .foregroundColor(.blue)
            
            Text("Sign In View")
                .font(.title)
        }
    }
}

#Preview {
    SignInView()
}
