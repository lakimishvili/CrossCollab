//
//  MainRootView.swift
//  EventHub
//
//  Created by Bacho on 22.12.25.
//

import SwiftUI

struct MainRootView: View {
    @StateObject private var viewModel: MainRootViewModel
    private let coordinator: MainCoordinator
    
    init(coordinator: MainCoordinator) {
        self.coordinator = coordinator
        _viewModel = StateObject(wrappedValue: MainRootViewModel(coordinator: coordinator))
    }
    
    var body: some View {
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
                
                coordinator.makeProfileView()
                    .tag(Tabs.profile)
                    .toolbarBackground(.hidden, for: .tabBar)
            }
            
            CustomTabBar(selectedTab: $viewModel.selectedTab)
                .edgesIgnoringSafeArea(.bottom)
        }
    }
}

#Preview {
    MainRootView(coordinator: MainCoordinator(appState: AppState()))
}
