//
//  RootCoordinatorView.swift
//  EventHub
//
//  Created by Bacho on 21.12.25.
//

import SwiftUI

struct RootCoordinatorView: View {
    @StateObject private var appState = AppState()
    
    var body: some View {
        currentView
            .animation(.easeInOut, value: appState.currentFlow)
    }
    
    @ViewBuilder
    private var currentView: some View {
        switch appState.currentFlow {
        case .authentication:
            AuthCoordinatorView(appState: appState)
                .transition(.scale.combined(with: .opacity))
        case .main:
            MainRootView(coordinator: MainCoordinator(appState: appState))
                .transition(.scale.combined(with: .opacity))
        }
    }
}

#Preview {
    RootCoordinatorView()
}
