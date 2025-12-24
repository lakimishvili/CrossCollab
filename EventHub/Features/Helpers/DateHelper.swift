//
//  DateHelper.swift
//  EventHub
//
//  Created by Bacho on 23.12.25.
//

import Foundation

struct DateHelper {
    
    // Multiple date formatters to handle different backend formats
    private static let iso8601Formatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter
    }()
    
    private static let iso8601FormatterNoFractional: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        return formatter
    }()
    
    private static let customFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSS"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }()
    
    private static let customFormatterNoFractional: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }()
    
    // Parse ISO 8601 date string to Date (tries multiple formats)
    static func parseDate(_ dateString: String) -> Date? {
        // Try ISO8601 with fractional seconds
        if let date = iso8601Formatter.date(from: dateString) {
            return date
        }
        
        // Try ISO8601 without fractional seconds
        if let date = iso8601FormatterNoFractional.date(from: dateString + "Z") {
            return date
        }
        
        // Try custom formatter with fractional seconds
        if let date = customFormatter.date(from: dateString) {
            return date
        }
        
        // Try custom formatter without fractional seconds
        if let date = customFormatterNoFractional.date(from: dateString) {
            return date
        }
        
        return nil
    }
    
    // Format date to display string
    static func formatDate(_ dateString: String, format: String = "MMM dd, yyyy") -> String {
        guard let date = parseDate(dateString) else {
            return dateString
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
    
    // Format time
    static func formatTime(_ dateString: String) -> String {
        guard let date = parseDate(dateString) else { return "" }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        return formatter.string(from: date)
    }
    
    // Get month and day
    static func getMonthDay(_ dateString: String) -> (month: String, day: String) {
        guard let date = parseDate(dateString) else {
            return ("", "")
        }
        
        let monthFormatter = DateFormatter()
        monthFormatter.dateFormat = "MMM"
        let month = monthFormatter.string(from: date).uppercased()
        
        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "dd"
        let day = dayFormatter.string(from: date)
        
        return (month, day)
    }
    
    static func isUpcoming(_ dateString: String) -> Bool {
        guard let date = parseDate(dateString) else {
            return false
        }
        return date > Date()
    }
    
    static func formatEventDate(_ dateString: String) -> String {
        let (month, day) = self.getMonthDay(dateString)
        return "\(month)\n\(day)"
    }
    
    static func formatEventTime(_ dateString: String) -> String {
        guard let date = self.parseDate(dateString) else { return "" }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        let startTime = formatter.string(from: date)
        
        let endDate = date.addingTimeInterval(7200)
        let endTime = formatter.string(from: endDate)
        
        return "\(startTime) - \(endTime)"
    }
    
    static func formatEventFooter(_ event: EventListItem) -> String {
        let spotsLeft = event.capacity - event.confirmedCount
        
        if event.isFull {
            return "\(event.confirmedCount) registered • Full"
        } else {
            return "\(event.confirmedCount) registered • \(spotsLeft) spots left"
        }
    }
}
