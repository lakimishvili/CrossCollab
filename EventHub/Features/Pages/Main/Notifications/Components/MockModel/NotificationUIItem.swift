//
//  NotificationUIItem.swift
//  EventHub
//
//  Created by Bacho on 25.12.25.
//

import Foundation

struct NotificationUIItem: Identifiable {
    let id = UUID()
    let icon: String
    let title: String
    let subtitle: String
    var isRead: Bool 
    let timestamp: String
    let detailMessage: String
    
    init(icon: String, title: String, subtitle: String, isRead: Bool, timestamp: String = "Just now", detailMessage: String? = nil) {
        self.icon = icon
        self.title = title
        self.subtitle = subtitle
        self.isRead = isRead
        self.timestamp = timestamp
        self.detailMessage = detailMessage ?? subtitle
    }
}
