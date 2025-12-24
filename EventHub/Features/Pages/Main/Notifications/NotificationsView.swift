//
//  NotificationsView.swift
//  EventHub
//
//  Created by Bacho on 22.12.25.
//
import SwiftUI

struct NotificationsView: View {
    
    @StateObject var viewModel: NotificationsViewModel

    @State private var selectedTab = "All"
    
    let tabs = ["All", "Registrations", "Reminders", "Updates"]
    
    // MARK: - Static UI Data
    
    let newNotifications: [NotificationUIItem] = [
        NotificationUIItem(
            icon: "calendar",
            title: "Registration Confirmed",
            subtitle: "You are now registered for 'Leadership Workshop: Effective Communication'.",
            isRead: false
        ),
        NotificationUIItem(
            icon: "bell",
            title: "Event Reminder",
            subtitle: "'Annual Team Building Summit' starts in 24 hours. Don't forget to join!",
            isRead: false
        )
    ]
    
    let earlierNotifications: [NotificationUIItem] = [
        NotificationUIItem(
            icon: "info.circle",
            title: "Event Update",
            subtitle: "The location for 'Happy Friday: Game Night' has been changed.",
            isRead: true
        ),
        NotificationUIItem(
            icon: "calendar.badge.minus",
            title: "Cancellation",
            subtitle: "Your registration for 'Wellness Wednesday Yoga' has been cancelled.",
            isRead: true
        )
    ]
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                
                NotificationTabsView(
                    selectedTab: $selectedTab,
                    tabs: tabs
                )
                
                Divider()
                
                ScrollView {
                    VStack(spacing: 24) {
                        
                        NotificationSectionView(
                            title: "New",
                            items: newNotifications
                        )
                        
                        NotificationSectionView(
                            title: "Earlier",
                            items: earlierNotifications
                        )
                    }
                    .padding(.top, 12)
                }
            }
            .background(Color("customWhite").ignoresSafeArea())
            .navigationTitle("Notifications")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}


#Preview {
    NotificationsView(viewModel: NotificationsViewModel())
}
