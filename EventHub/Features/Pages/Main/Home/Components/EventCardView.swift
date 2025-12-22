//
//  EventCardView.swift
//  EventHub
//
//  Created by LILIANA on 12/22/25.
//
import SwiftUI

struct EventCardView: View {
    
    let date: String
    let title: String
    let time: String
    let location: String
    let footer: String
    var isDisabled: Bool = false
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Text(date)
                .multilineTextAlignment(.center)
                .foregroundColor(.black)
            
            VStack(alignment: .leading, spacing: 8) {
                
                Text(title)
                HStack(spacing: 12) {
                    
                    HStack(spacing: 4) {
                        Image(systemName: "clock")
                            .font(.caption)
                        Text(time)
                            .font(.caption)
                    }
                    
                    HStack(spacing: 4) {
                        Image(systemName: "location.fill")
                            .font(.caption)
                        Text(location)
                            .font(.caption)
                    }
                }
                .foregroundColor(.gray)
                
                Text("Join us for a full day of engaging activities and networking opportunities.")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                HStack {
                    HStack(spacing: 4) {
                        Image(systemName: "person.3.fill")
                            .font(.caption2)
                        
                        Text(footer)
                            .font(.caption2)
                    }
                    .foregroundColor(.gray)
                    
                    Spacer()
                    
                    Text("View Details →")
                        .font(.caption)
                        .foregroundColor(.black)
                }
            }
        }
        .padding(12)
        .background(Color.clear)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.gray.opacity(0.4), lineWidth: 1)
        )
        .cornerRadius(8)
        .opacity(isDisabled ? 0.5 : 1)
    }
}
