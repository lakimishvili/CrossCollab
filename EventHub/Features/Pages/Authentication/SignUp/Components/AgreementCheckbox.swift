//
//  AgreementCheckbox.swift
//  EventHub
//
//  Created by Bacho on 21.12.25.
//


import SwiftUI

struct AgreementCheckbox: View {
    @Binding var isAgreed: Bool
    let action: () -> Void
    
    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            Button(action: {
                isAgreed.toggle()
            }) {
                Image(systemName: isAgreed ? "checkmark.square.fill" : "square")
                    .foregroundColor(isAgreed ? .black : .gray)
                    .font(.system(size: 20))
            }
            
            (Text("I agree to the ")
                .foregroundColor(.gray)
                .font(.system(size: 14))
             +
             Text("Terms of Service and Privacy Policy")
                .foregroundColor(.black))
            .font(.system(size: 14))
            .onTapGesture {
                action()
            }
            
            Spacer()
        }
    }
}

#Preview {
    AgreementCheckbox(isAgreed: .constant(false), action: {
        print("Terms tapped")
    })
    .padding()
}
