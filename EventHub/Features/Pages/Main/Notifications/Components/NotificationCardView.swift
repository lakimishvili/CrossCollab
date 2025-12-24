//
//  NotificationCardView.swift
//  EventHub
//
//  Created by LILIANA on 12/24/25.
//

import SwiftUI

struct NotificationUIItem: Identifiable {
    let id = UUID()
    let icon: String
    let title: String
    let subtitle: String
    let isRead: Bool
}

struct NotificationCardView: View {
    
    let item: NotificationUIItem
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            
            Image(systemName: item.icon)
                .frame(width: 32, height: 32)
                .background(Color.gray.opacity(0.15))
                .cornerRadius(6)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(item.title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                Text(item.subtitle)
                    .font(.footnote)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            if !item.isRead {
                Circle()
                    .fill(Color.blue)
                    .frame(width: 8, height: 8)
            }
        }
        .padding()
        .background(Color.white)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.gray.opacity(0.25), lineWidth: 1)
        )
        .cornerRadius(8)
    }
}
