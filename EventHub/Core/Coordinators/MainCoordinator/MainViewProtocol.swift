//
//  MainViewProtocol.swift
//  EventHub
//
//  Created by Bacho on 22.12.25.
//

protocol MainViewProtocol {
    func makeHomeView() -> HomeView
    func makeBrowseView() -> BrowseView
    func makeEventsView() -> EventsView
    func makeNotificationsView() -> NotificationsView
    func makeProfileView() -> ProfileView
}
