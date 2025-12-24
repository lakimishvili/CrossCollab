//
//  EmptyMyEventsView.swift
//  EventHub
//
//  Created by Bacho on 24.12.25.
//

import SwiftUI


struct EmptyMyEventsView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "calendar.badge.exclamationmark")
                .font(.system(size: 50))
                .foregroundColor(.gray)
            
            Text("No Registered Events")
                .font(.system(size: 20, weight: .semibold))
            
            Text("Browse events and register to see them here")
                .font(.system(size: 14))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
