//
//  OTPVerificationView.swift
//  EventHub
//
//  Created by Bacho on 21.12.25.
//


import SwiftUI

struct OTPVerificationView: View {
    @Binding var otpCode: [String]
    @Binding var timeRemaining: Int
    @Binding var isOTPSent: Bool
    let onResend: () -> Void
    let onOTPChange: (Int, String, String) -> Void
    
    @FocusState private var focusedField: Int?
    
    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 5) {
                ForEach(0..<6) { index in
                    OTPBox(text: $otpCode[index], isFocused: focusedField == index)
                        .focused($focusedField, equals: index)
                        .onChange(of: otpCode[index]) { oldValue, newValue in
                            onOTPChange(index, oldValue, newValue)
                            
                            if !newValue.isEmpty && index < 5 {
                                focusedField = index + 1
                            }
                            if newValue.isEmpty && !oldValue.isEmpty && index > 0 {
                                focusedField = index - 1
                            }
                        }
                }
            }
            
            if isOTPSent {
                HStack {
                    Text("Code expires in \(String(format: "%02d:%02d", timeRemaining / 60, timeRemaining % 60))")
                        .font(.callout)
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                    Button("Resend Code") {
                        onResend()
                    }
                    .font(.callout)
                    .foregroundColor(timeRemaining > 0 ? .gray : .black)
                    .disabled(timeRemaining > 0)
                }
            }
        }
        .onAppear {
            if isOTPSent {
                focusedField = 0
            }
        }
    }
}

struct OTPBox: View {
    @Binding var text: String
    var isFocused: Bool
    
    var body: some View {
        TextField("", text: $text)
            .keyboardType(.numberPad)
            .multilineTextAlignment(.center)
            .font(.title2)
            .frame(width: 50, height: 50)
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(isFocused ? Color.blue : Color(.systemGray4), lineWidth: isFocused ? 2 : 1)
            )
    }
}

#Preview {
    OTPVerificationView(
        otpCode: .constant(Array(repeating: "", count: 6)),
        timeRemaining: .constant(50),
        isOTPSent: .constant(true),
        onResend: {},
        onOTPChange: { _, _, _ in }
    )
    .padding()
}
