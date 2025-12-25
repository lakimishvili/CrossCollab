//
//  MainRootView.swift
//  EventHub
//
//  Created by Bacho on 22.12.25.
//

import SwiftUI

struct MainRootView: View {
    @StateObject private var viewModel: MainRootViewModel
    @StateObject var coordinator: MainCoordinator
    
    init(coordinator: MainCoordinator) {
        _coordinator = StateObject(wrappedValue: coordinator)
        _viewModel = StateObject(wrappedValue: MainRootViewModel(coordinator: coordinator))
    }
    
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            ZStack(alignment: .bottom) {
                TabView(selection: $viewModel.selectedTab) {
                    coordinator.makeHomeView()
                        .tag(Tabs.home)
                        .toolbarBackground(.hidden, for: .tabBar)
                    
                    coordinator.makeBrowseView()
                        .tag(Tabs.browse)
                        .toolbarBackground(.hidden, for: .tabBar)
                    
                    coordinator.makeEventsView()
                        .tag(Tabs.events)
                        .toolbarBackground(.hidden, for: .tabBar)
                    
                    coordinator.makeNotificationsView()
                        .tag(Tabs.notifications)
                        .toolbarBackground(.hidden, for: .tabBar)
                }
                
                .navigationDestination(for: MainRoute.self) { route in
                    switch route {
                    case .allEvents:
                        coordinator.makeAllEventsView()
                    case .eventDetails(let id):
                        coordinator.makeEventDetailsView(eventId: id) 
                    case .profile:
                        coordinator.makeProfileView()
                    }
                }
                
                CustomTabBar(selectedTab: $viewModel.selectedTab)
                    .edgesIgnoringSafeArea(.bottom)
            }
        }
    }
}

#Preview {
    MainRootView(coordinator: MainCoordinator(appState: AppState()))
}
