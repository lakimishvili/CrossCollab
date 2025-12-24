//
//  Event.swift
//  EventHub
//
//  Created by Bacho on 24.12.25.
//


import Foundation

struct Event: Identifiable {
    let id: Int
    let title: String
    let eventTypeName: String
    let startDateTime: String
    let location: String
    let status: RegistrationStatus?
    
    init(id: Int, title: String, eventTypeName: String, startDateTime: String, location: String, status: RegistrationStatus? = nil) {
        self.id = id
        self.title = title
        self.eventTypeName = eventTypeName
        self.startDateTime = startDateTime
        self.location = location
        self.status = status
    }
}
