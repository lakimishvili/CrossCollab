//
//  CategoryChipsView.swift
//  EventHub
//
//  Created by LILIANA on 12/23/25.
//
import SwiftUI

struct CategoryChipsView: View {
    let categories: [String]
    let selectedIndex: Int
    let onSelect: (Int) -> Void
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(Array(categories.enumerated()), id: \.offset) { index, category in
                    CategoryChip(
                        title: category,
                        isSelected: index == selectedIndex
                    )
                    .onTapGesture {
                        onSelect(index)
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}

struct CategoryChip: View {
    let title: String
    let isSelected: Bool
    
    var body: some View {
        Text(title)
            .font(.system(size: 14))
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(isSelected ? Color.black : Color.white)
            .foregroundColor(isSelected ? .white : .black)
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
            )
    }
}
