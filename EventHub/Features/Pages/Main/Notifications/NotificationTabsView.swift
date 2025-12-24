//
//  NotificationTabsView.swift
//  EventHub
//
//  Created by LILIANA on 12/24/25.
//

import SwiftUI

struct NotificationTabsView: View {
    
    @Binding var selectedTab: String
    let tabs: [String]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20) {
                ForEach(tabs, id: \.self) { tab in
                    Text(tab)
                        .font(.subheadline)
                        .fontWeight(selectedTab == tab ? .semibold : .regular)
                        .foregroundColor(selectedTab == tab ? .black : .gray)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 12)
                        .background(
                            selectedTab == tab
                            ? Color.gray.opacity(0.2)
                            : Color.clear
                        )
                        .cornerRadius(10)
                        .onTapGesture {
                            selectedTab = tab
                        }
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
        }
    }
}
