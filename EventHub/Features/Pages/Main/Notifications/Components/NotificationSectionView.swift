//
//  NotificationSectionView.swift
//  EventHub
//
//  Created by LILIANA on 12/24/25.
//
import SwiftUI

struct NotificationSectionView: View {
    
    let title: String
    let items: [NotificationUIItem]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            Text(title.uppercased())
                .font(.footnote)
                .fontWeight(.semibold)
                .foregroundColor(.gray)
                .padding(.horizontal)
            
            VStack(spacing: 12) {
                ForEach(items) { item in
                    NotificationCardView(item: item)
                }
            }
            .padding(.horizontal)
        }
    }
}
