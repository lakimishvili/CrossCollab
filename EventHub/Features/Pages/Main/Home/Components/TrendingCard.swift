//
//  TrendingCard.swift
//  EventHub
//
//  Created by LILIANA on 12/22/25.
//

import SwiftUI

struct TrendingCard: View {
    
    let title: String
    let date: String
    let image: String
    let size: CGFloat
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            VStack(spacing: 0) {
                
                PosterView(imageURL: image, size: size)
                
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 1)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                
                Text(title)
                    .font(.caption)
                    .foregroundColor(.black)
                
                HStack(spacing: 4) {
                    Image(systemName: "calendar")
                        .font(.caption2)
                    
                    Text(date)
                        .font(.caption2)
                }
                .foregroundColor(.gray)
            }
            .padding(8)
        }
        .background(Color.white)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
        )
        .cornerRadius(8)
        .shadow(color: Color.black.opacity(0.08), radius: 6, x: 0, y: 4)
        .frame(width: 180)
        .clipped()
    }
}

