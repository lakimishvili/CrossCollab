//
//  UserRole.swift
//  EventHub
//
//  Created by Bacho on 22.12.25.
//

import Foundation

enum UserRole: String, Codable {
    case employee = "Employee"
    case organizer = "Organizer"
    case admin = "Admin"
    
    var displayName: String {
        rawValue
    }
    
    var canCreateEvents: Bool {
        self == .organizer || self == .admin
    }
    
    var canAccessAnalytics: Bool {
        self == .organizer || self == .admin
    }
    
    var isAdmin: Bool {
        self == .admin
    }
}
