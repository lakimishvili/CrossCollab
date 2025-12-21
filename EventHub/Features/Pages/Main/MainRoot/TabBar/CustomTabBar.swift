//
//  CustomTabBar.swift
//  EventHub
//
//  Created by Bacho on 22.12.25.
//


import SwiftUI

struct CustomTabBar: View {
    
    @Binding var selectedTab: Tabs
    private let items: [TabItem] = [
        TabItem(imageName: "home", buttonText: "Home", type: .home),
        TabItem(imageName: "search", buttonText: "Browse", type: .browse),
        TabItem(imageName: "ticket", buttonText: "My Events", type: .events),
        TabItem(imageName: "bell", buttonText: "Notifications", type: .notifications),
        TabItem(imageName: "profile", buttonText: "Profile", type: .profile)
    ]
    
    var body: some View {
        
        VStack {
            
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .frame(height: 1)
            
            HStack(spacing: 0) {
                ForEach(items.indices, id: \.self) { index in
                    TabBarButton(
                        buttonText: items[index].buttonText,
                        imageName: items[index].imageName,
                        isActive: selectedTab == items[index].type,
                        scale: 1
                        
                    )
                    .frame(maxWidth: .infinity)
                    .onTapGesture {
                        withAnimation(.spring(response: 0.2, dampingFraction: 0.6)) {
                            selectedTab = items[index].type
                        }
                    }
                }
                .padding(.vertical, 10)
                .background(Color(.systemBackground))
                
            }
        }
    }
}
