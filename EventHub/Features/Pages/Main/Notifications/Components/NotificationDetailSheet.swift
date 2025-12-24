//
//  NotificationDetailSheet.swift
//  EventHub
//
//  Created by Bacho on 25.12.25.
//

import SwiftUI

struct NotificationDetailSheet: View {
    let notification: NotificationUIItem
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            Capsule()
                .fill(Color.gray.opacity(0.3))
                .frame(width: 40, height: 4)
                .padding(.top, 8)
            
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    Image(systemName: notification.icon)
                        .font(.title2)
                        .foregroundColor(.blue)
                        .frame(width: 44, height: 44)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(12)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(notification.title)
                            .font(.headline)
                        
                        Text(notification.timestamp)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                }
                
                Divider()
                
                Text(notification.detailMessage)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
                
                Spacer()
                
                Button {
                    dismiss()
                } label: {
                    Text("Got it")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.black)
                        .cornerRadius(12)
                }
            }
            .padding()
        }
        .frame(maxHeight: 400)
        .presentationDetents([.height(400)])
        .presentationDragIndicator(.hidden)
    }
}
