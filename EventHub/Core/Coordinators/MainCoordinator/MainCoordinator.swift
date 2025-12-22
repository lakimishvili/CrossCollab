//
//  MainCoordinator.swift
//  EventHub
//
//  Created by Bacho on 22.12.25.
//

import Foundation

@MainActor
class MainCoordinator: ObservableObject, MainCoordinatorProtocol, MainViewProtocol {
    private weak var appState: AppState?
    
    init(appState: AppState) {
        self.appState = appState
    }
    
    func logout() {
        appState?.logout()
    }
    
    // MARK: - View Factory Methods
    
    func makeHomeView() -> HomeView {
        let viewModel = HomeViewModel(coordinator: self)
        return HomeView(viewModel: viewModel)
    }
    
    func makeBrowseView() -> BrowseView {
        let viewModel = BrowseViewModel(coordinator: self)
        return BrowseView(viewModel: viewModel)
    }
    
    func makeEventsView() -> EventsView {
        let viewModel = EventsViewModel(coordinator: self)
        return EventsView(viewModel: viewModel)
    }
    
    func makeNotificationsView() -> NotificationsView {
        let viewModel = NotificationsViewModel(coordinator: self)
        return NotificationsView(viewModel: viewModel)
    }
    
    func makeProfileView() -> ProfileView {
        let viewModel = ProfileViewModel(coordinator: self)
        return ProfileView(viewModel: viewModel)
    }
}
