//
//  CategoryItem.swift
//  EventHub
//
//  Created by LILIANA on 12/22/25.
//
import SwiftUI

struct CategoryItem: View {
    
    let icon: String
    let title: String
    let count: String
    
    var body: some View {
        VStack(spacing: 8) {
            
            Image(icon)
                .font(.title2)
                .foregroundColor(.black)
            
            Text(title)
                .font(.caption.bold())
                .foregroundColor(.black)
            
            Text(count)
                .font(.caption2)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.clear)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.gray.opacity(0.4), lineWidth: 1)
        )
        .cornerRadius(8)
    }
}
