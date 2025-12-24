//
//  NotificationsViewModel.swift
//  EventHub
//
//  Created by Bacho on 22.12.25.
//

import Combine
import Foundation

@MainActor
final class NotificationsViewModel: ObservableObject {
    
    @Published var newNotifications: [NotificationUIItem] = []
    @Published var earlierNotifications: [NotificationUIItem] = []
    @Published var selectedTab: String = "All"
    @Published var selectedNotification: NotificationUIItem?
    @Published var showNotificationDetail = false
    
    weak var coordinator: MainCoordinatorProtocol?
    private let eventService: EventService
    private weak var appState: AppState?
    
    init(
        coordinator: MainCoordinatorProtocol? = nil,
        eventService: EventService = EventService.shared,
        appState: AppState? = nil
    ) {
        self.coordinator = coordinator
        self.eventService = eventService
        self.appState = appState
    }
    
    func loadNotifications() async {
        guard let userId = appState?.currentUserId else {
            loadStaticNotifications()
            return
        }
        
        do {
            let registrations = try await eventService.getUserRegistrations(userId: userId)
            
            var newItems: [NotificationUIItem] = []
            var earlierItems: [NotificationUIItem] = []
            
            // Recent registration confirmations
            for (index, registration) in registrations.prefix(2).enumerated() {
                newItems.append(NotificationUIItem(
                    icon: "calendar.badge.checkmark",
                    title: "Registration Confirmed",
                    subtitle: "You are now registered for '\(registration.eventTitle)'.",
                    isRead: index > 0
                ))
            }
            
            // Event reminder for upcoming event
            if let upcoming = registrations.first {
                newItems.append(NotificationUIItem(
                    icon: "bell.badge",
                    title: "Event Reminder",
                    subtitle: "'\(upcoming.eventTitle)' is starting soon. See you there!",
                    isRead: false
                ))
            }
            
            // Waitlist notification (if applicable)
            if registrations.contains(where: { $0.status == .waitlisted }) {
                if let waitlisted = registrations.first(where: { $0.status == .waitlisted }) {
                    newItems.append(NotificationUIItem(
                        icon: "hourglass",
                        title: "Waitlist Status",
                        subtitle: "You're on the waitlist for '\(waitlisted.eventTitle)'. We'll notify you if a spot opens up.",
                        isRead: false
                    ))
                }
            }
            
            // Event update
            if registrations.count > 1 {
                earlierItems.append(NotificationUIItem(
                    icon: "info.circle.fill",
                    title: "Event Update",
                    subtitle: "The location for '\(registrations[1].eventTitle)' has been updated. Check event details.",
                    isRead: true
                ))
            }
            
            // Cancellation reminder (24 hour policy)
            if let event = registrations.first {
                earlierItems.append(NotificationUIItem(
                    icon: "exclamationmark.triangle",
                    title: "Cancellation Reminder",
                    subtitle: "Remember: You can cancel '\(event.eventTitle)' up to 24 hours before start time.",
                    isRead: true
                ))
            }
            
            // New events available
            earlierItems.append(NotificationUIItem(
                icon: "star.fill",
                title: "New Events Available",
                subtitle: "5 new company events have been added this week. Check them out!",
                isRead: true
            ))
            
            // Event feedback request (for past events)
            if registrations.count > 2 {
                earlierItems.append(NotificationUIItem(
                    icon: "hand.thumbsup",
                    title: "Feedback Requested",
                    subtitle: "How was '\(registrations[2].eventTitle)'? Share your experience to help us improve.",
                    isRead: true
                ))
            }
            
            // Capacity alert
            earlierItems.append(NotificationUIItem(
                icon: "person.3.fill",
                title: "Event Almost Full",
                subtitle: "Only 3 spots left for 'Leadership Workshop'! Register now to secure your place.",
                isRead: true
            ))
            
            // Welcome notification
            earlierItems.append(NotificationUIItem(
                icon: "sparkles",
                title: "Welcome to EventHub!",
                subtitle: "Discover company events, connect with colleagues, and build lasting memories together.",
                isRead: true
            ))
            
            newNotifications = newItems
            earlierNotifications = earlierItems
            
        } catch {
            loadStaticNotifications()
        }
    }
    
    private func loadStaticNotifications() {
        newNotifications = [
            NotificationUIItem(
                icon: "calendar.badge.checkmark",
                title: "Registration Confirmed",
                subtitle: "You are now registered for 'Team Building Workshop'.",
                isRead: false
            ),
            NotificationUIItem(
                icon: "bell.badge",
                title: "Event Reminder",
                subtitle: "'Annual Team Summit' starts tomorrow at 10:00 AM. Don't forget to join!",
                isRead: false
            ),
            NotificationUIItem(
                icon: "hourglass",
                title: "Waitlist Update",
                subtitle: "A spot opened up! You can now register for 'Leadership Training'.",
                isRead: false
            )
        ]
        
        earlierNotifications = [
            NotificationUIItem(
                icon: "info.circle.fill",
                title: "Event Update",
                subtitle: "The location for 'Happy Friday: Game Night' has been changed to Conference Room A.",
                isRead: true
            ),
            NotificationUIItem(
                icon: "exclamationmark.triangle",
                title: "Cancellation Deadline",
                subtitle: "Reminder: Cancel 'Yoga Session' before 24 hours to avoid penalties.",
                isRead: true
            ),
            NotificationUIItem(
                icon: "star.fill",
                title: "New Events Available",
                subtitle: "8 new company events added this week. Check out Sports, Workshops & more!",
                isRead: true
            ),
            NotificationUIItem(
                icon: "hand.thumbsup",
                title: "Feedback Requested",
                subtitle: "How was 'Team Building Retreat'? Help us improve by sharing your experience.",
                isRead: true
            ),
            NotificationUIItem(
                icon: "person.3.fill",
                title: "Event Almost Full",
                subtitle: "Only 2 spots left for 'AI Workshop'! Register now to secure your place.",
                isRead: true
            ),
            NotificationUIItem(
                icon: "sparkles",
                title: "Welcome to EventHub!",
                subtitle: "Discover company events, connect with colleagues, and build lasting memories.",
                isRead: true
            )
        ]
    }
    
    func openNotification(_ notification: NotificationUIItem) {
        markAsRead(notification)
        selectedNotification = notification
        showNotificationDetail = true
    }
    
    private func markAsRead(_ notification: NotificationUIItem) {
        if let index = newNotifications.firstIndex(where: { $0.id == notification.id }) {
            newNotifications[index].isRead = true
        }
        
        if let index = earlierNotifications.firstIndex(where: { $0.id == notification.id }) {
            earlierNotifications[index].isRead = true
        }
    }
}
