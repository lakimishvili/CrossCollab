//
//  NumberInputView.swift
//  EventHub
//
//  Created by Bacho on 21.12.25.
//

import SwiftUI

struct NumberInputView: View {
    
    @Binding var number: String
    let action: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Phone Number")
                .font(.callout)
            
            HStack(spacing: 12) {
                TextField("+1 (000) 000-0000", text: $number)
                    .keyboardType(.phonePad)
                    .font(.callout)
                    .padding()
                    .frame(height: 40)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color(.systemGray4), lineWidth: 1)
                    )
                
                Button(action: {
                    action()
                }) {
                    Text("Send OTP")
                        .font(.callout)
                        .foregroundColor(.primary)
                        .frame(height: 10)
                        .padding()
                        .background(Color(.systemGray6))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color(.systemGray4), lineWidth: 1)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            }
        }
    }
}
