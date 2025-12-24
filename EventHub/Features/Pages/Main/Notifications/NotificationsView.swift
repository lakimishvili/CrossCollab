//
//  NotificationsView.swift
//  EventHub
//
//  Created by Bacho on 22.12.25.
//

import SwiftUI

struct NotificationsView: View {
    
    @StateObject var viewModel: NotificationsViewModel
    
    let tabs = ["All", "Registrations", "Reminders", "Updates"]
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                
                NotificationTabsView(
                    selectedTab: $viewModel.selectedTab,
                    tabs: tabs
                )
                
                Divider()
                
                ScrollView {
                    VStack(spacing: 24) {
                        
                        if !viewModel.newNotifications.isEmpty {
                            NotificationSectionView(
                                title: "New",
                                items: filteredNotifications(viewModel.newNotifications),
                                onTap: { notification in  // ✅ Handle tap
                                    viewModel.openNotification(notification)
                                }
                            )
                        }
                        
                        if !viewModel.earlierNotifications.isEmpty {
                            NotificationSectionView(
                                title: "Earlier",
                                items: filteredNotifications(viewModel.earlierNotifications),
                                onTap: { notification in  // ✅ Handle tap
                                    viewModel.openNotification(notification)
                                }
                            )
                        }
                        
                        if viewModel.newNotifications.isEmpty && viewModel.earlierNotifications.isEmpty {
                            VStack(spacing: 16) {
                                Image(systemName: "bell.slash")
                                    .font(.system(size: 48))
                                    .foregroundColor(.gray)
                                
                                Text("No Notifications")
                                    .font(.headline)
                                
                                Text("You're all caught up!")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.top, 100)
                        }
                    }
                    .padding(.top, 12)
                }
            }
            .background(Color("customWhite").ignoresSafeArea())
            .navigationTitle("Notifications")
            .navigationBarTitleDisplayMode(.inline)
            .task {
                await viewModel.loadNotifications()
            }
            .refreshable {
                await viewModel.loadNotifications()
            }
            .sheet(isPresented: $viewModel.showNotificationDetail) {
                if let notification = viewModel.selectedNotification {
                    NotificationDetailSheet(notification: notification)
                }
            }
        }
    }
    
    // MARK: - Filter notifications by selected tab
    private func filteredNotifications(_ items: [NotificationUIItem]) -> [NotificationUIItem] {
        switch viewModel.selectedTab {
        case "All":
            return items
        case "Registrations":
            return items.filter {
                $0.icon == "calendar.badge.checkmark" ||
                $0.icon == "hourglass" ||
                $0.icon == "calendar.badge.minus"
            }
        case "Reminders":
            return items.filter {
                $0.icon == "bell.badge" ||
                $0.icon == "exclamationmark.triangle" ||
                $0.icon == "clock"
            }
        case "Updates":
            return items.filter {
                $0.icon == "info.circle.fill" ||
                $0.icon == "star.fill" ||
                $0.icon == "hand.thumbsup" ||
                $0.icon == "person.3.fill"
            }
        default:
            return items
        }
    }
}

#Preview {
    NotificationsView(viewModel: NotificationsViewModel())
}
