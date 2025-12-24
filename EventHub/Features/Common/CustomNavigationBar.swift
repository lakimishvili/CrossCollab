//
//  CustomNavigationBar.swift
//  EventHub
//
//  Created by Bacho on 25.12.25.
//

import SwiftUI

struct CustomNavigationBar: View {
    let title: String
    let onBack: () -> Void
    
    var body: some View {
        HStack {
            Button(action: onBack) {
                Image(systemName: "chevron.left")
                    .font(.title2)
                    .foregroundColor(.primary)
            }
            
            Spacer()
            
            Text(title)
                .font(.title3)
                .fontWeight(.semibold)
            
            Spacer()
            
            Image(systemName: "ellipsis")
                .font(.title2)
                .foregroundColor(.primary)
                .rotationEffect(.degrees(90))
        }
        .padding(.horizontal)
        .frame(height: 56)
    }
}
