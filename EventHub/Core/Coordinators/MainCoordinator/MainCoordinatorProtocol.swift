//
//  MainCoordinatorProtocol.swift
//  EventHub
//
//  Created by Bacho on 22.12.25.
//

import SwiftUI

protocol MainCoordinatorProtocol: AnyObject {
    @MainActor var path: NavigationPath { get set }
    @MainActor func pop()
    @MainActor func logout()
    @MainActor func goAllEventsPage()
    @MainActor func goEventsDetails(id: Int)
    @MainActor func makeProfileView() -> ProfileView
}
