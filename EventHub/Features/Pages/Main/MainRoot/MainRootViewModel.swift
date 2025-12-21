//
//  MainRootViewModel.swift
//  EventHub
//
//  Created by Bacho on 22.12.25.
//

import Foundation

final class MainRootViewModel: ObservableObject {
    @Published var selectedTab: Tabs = .home
    
    weak var coordinator: MainCoordinatorProtocol?
    
    init(coordinator: MainCoordinatorProtocol? = nil) {
        self.coordinator = coordinator
    }
    
}
