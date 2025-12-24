//
//  MainCoordinator.swift
//  EventHub
//
//  Created by Bacho on 22.12.25.
//

import Foundation
import SwiftUI

@MainActor
class MainCoordinator: ObservableObject, MainCoordinatorProtocol, MainViewProtocol {
    
    @Published var path = NavigationPath()
    
    private weak var appState: AppState?
    
    init(appState: AppState) {
        self.appState = appState
    }
    
    func logout() {
        appState?.logout()
    }
    
    func goAllEventsPage() {
        path.append(MainRoute.allEvents)
    }
    
    func goEventsDetails(id: Int) {
        path.append(MainRoute.eventDetails(id: id))
    }
    
    func showProfilePage() {
        path.append(MainRoute.profile)
    }

    
    // MARK: - View Factory Methods
    
    func makeHomeView() -> HomeView {
        let viewModel = HomeViewModel(
            coordinator: self,
            appState: appState
        )
        return HomeView(viewModel: viewModel)
    }
    
    func makeBrowseView() -> BrowseView {
        let viewModel = BrowseViewModel(coordinator: self)
        return BrowseView(viewModel: viewModel)
    }
    
    func makeEventsView() -> EventsView {
        let viewModel = EventsViewModel(
            coordinator: self,
            appState: appState
        )
        return EventsView(viewModel: viewModel)
    }
    
    func makeNotificationsView() -> NotificationsView {
        let viewModel = NotificationsViewModel(coordinator: self)
        return NotificationsView(viewModel: viewModel)
    }
    
    func makeProfileView() -> ProfileView {
        let viewModel = ProfileViewModel(
            coordinator: self,
        )
        return ProfileView(viewModel: viewModel)
    }
    
    func makeEventDetailsView(eventId: Int) -> EventDetailsView {
        let viewModel = EventDetailsViewModel(
            eventId: eventId,
            appState: appState
        )
        return EventDetailsView(viewModel: viewModel)
    }
}
