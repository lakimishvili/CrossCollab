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

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(categories.indices, id: \.self) { index in
                    Text(categories[index])
                        .font(.caption)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(
                            index == selectedIndex
                            ? Color.black
                            : Color.clear
                        )
                        .foregroundColor(
                            index == selectedIndex
                            ? .white
                            : .black
                        )
                        .overlay(
                            Capsule()
                                .stroke(Color.gray.opacity(0.3))
                        )
                        .clipShape(Capsule())
                }
            }
        }
    }
}
