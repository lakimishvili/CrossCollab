//
//  MainViewProtocol.swift
//  EventHub
//
//  Created by Bacho on 22.12.25.
//

protocol MainViewProtocol {
    @MainActor func makeHomeView() -> HomeView
    @MainActor func makeBrowseView() -> BrowseView
    @MainActor func makeEventsView() -> EventsView
    @MainActor func makeNotificationsView() -> NotificationsView
    @MainActor func makeProfileView() -> ProfileView
}
