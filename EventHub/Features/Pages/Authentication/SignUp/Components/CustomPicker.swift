//
//  CustomPicker.swift
//  EventHub
//
//  Created by Bacho on 21.12.25.
//


import SwiftUI

struct CustomPicker: View {
    let title: String
    let placeholder: String
    @Binding var selection: String
    let options: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.callout)
            
            Menu {
                ForEach(options, id: \.self) { option in
                    Button(option) {
                        selection = option
                    }
                }
            } label: {
                HStack {
                    Text(selection.isEmpty ? placeholder : selection)
                        .foregroundColor(selection.isEmpty ? .gray : .primary)
                        .font(.callout)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.down")
                        .foregroundColor(.black)
                }
                .padding()
                .frame(height: 40)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color(.systemGray4), lineWidth: 1)
                )
            }
        }
    }
}
