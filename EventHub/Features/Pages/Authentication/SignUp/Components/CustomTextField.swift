//
//  CustomTextField.swift
//  EventHub
//
//  Created by Bacho on 20.12.25.
//

import SwiftUI

struct CustomTextField: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    var isPassword: Bool = false
    var helperText: String? = nil
    var showInfoIcon: Bool = false
    
    @State private var showHelperText: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            
            HStack {
                Text(title)
                    .font(.callout)
                
                Spacer()

                if showInfoIcon {
                    Button(action: {
                        showHelperText.toggle()
                    }) {
                        Image("info")
                            .resizable()
                            .frame(width: 16, height: 16)
                            
                    }
                    .offset(y: 5)
                }
                
            }
            
            Group {
                if isPassword {
                    SecureField(placeholder, text: $text)
                } else {
                    TextField(placeholder, text: $text)
                }
            }
            .padding()
            .font(.callout)
            .autocorrectionDisabled()
            .textInputAutocapitalization(.never)
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(Color(.systemGray4), lineWidth: 1)
                    .frame(height: 40)
            )
            
            
            if showHelperText, let helperText = helperText {
                Text(helperText)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(.top, -5)
            }
        }
    }
}
