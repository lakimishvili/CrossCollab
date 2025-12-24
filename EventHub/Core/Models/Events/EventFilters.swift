//
//  EventFilters.swift
//  EventHub
//
//  Created by Bacho on 24.12.25.
//

import Foundation

struct EventFilters {
    var eventTypeId: Int?
    var location: String?
    var searchKeyword: String?
    var startDate: String?
    var endDate: String?
    var onlyAvailable: Bool?
    
    var queryParams: [String: String] {
        var params: [String: String] = [:]
        
        if let eventTypeId = eventTypeId {
            params["eventTypeId"] = "\(eventTypeId)"
        }
        if let location = location, !location.isEmpty {
            params["location"] = location
        }
        if let searchKeyword = searchKeyword, !searchKeyword.isEmpty {
            params["searchKeyword"] = searchKeyword
        }
        if let startDate = startDate {
            params["startDate"] = startDate
        }
        if let endDate = endDate {
            params["endDate"] = endDate
        }
        if let onlyAvailable = onlyAvailable {
            params["onlyAvailable"] = "\(onlyAvailable)"
        }
        
        return params
    }
}
