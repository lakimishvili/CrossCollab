//
//  EventDetailCard.swift
//  EventHub
//
//  Created by Bacho on 24.12.25.
//

import SwiftUI

struct EventDetailCard: View {
    let event: Event
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            VStack {
                Text(formatHour(event.startDateTime))
                    .font(.title3)
                    .fontWeight(.semibold)
                Text(formatAMPM(event.startDateTime))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .frame(width: 60)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(event.title)
                    .font(.headline)
                
                Text(event.eventTypeName)
                    .font(.subheadline)
                    .foregroundColor(.blue)
                
                HStack(spacing: 6) {
                    Image(systemName: "mappin.and.ellipse")
                    Text(event.location)
                }
                .font(.caption)
                .foregroundColor(.gray)
            }
            
            Spacer()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.1), radius: 4)
        .padding(.horizontal)
    }
    
    private func formatHour(_ dateString: String) -> String {
        guard let date = DateHelper.parseDate(dateString) else { return "TBA" }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm"
        return formatter.string(from: date)
    }
    
    private func formatAMPM(_ dateString: String) -> String {
        guard let date = DateHelper.parseDate(dateString) else { return "" }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "a"
        return formatter.string(from: date)
    }
}
