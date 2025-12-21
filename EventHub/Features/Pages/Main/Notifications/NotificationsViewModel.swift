//
//  NotificationsViewModel.swift
//  EventHub
//
//  Created by Bacho on 22.12.25.
//

import Combine

final class NotificationsViewModel: ObservableObject {
    
    weak var coordinator: MainCoordinatorProtocol?
    
    init(coordinator: MainCoordinatorProtocol? = nil) {
        self.coordinator = coordinator
    }
}
