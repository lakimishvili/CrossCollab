//
//  HomeViewModel.swift
//  EventHub
//
//  Created by Bacho on 22.12.25.
//

import Combine

@MainActor
final class HomeViewModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published var upcomingEvents: [EventListItem] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var selectedCategoryName: String?

    
    // MARK: - Dependencies
    weak var coordinator: MainCoordinatorProtocol?
    
    private let eventService: EventService
    private weak var appState: AppState?
    
    
    // MARK: - User Info
    var userName: String {
        appState?.currentUserName?.components(separatedBy: " ").first?.capitalized ?? "User"
    }
    
    var userRole: String {
        appState?.currentUserRole ?? "Employee"
    }
    
    var hasUnread: Bool {
        appState?.hasUnreadNotifications ?? false
    }
    
    // MARK: - Init
    init(
        coordinator: MainCoordinatorProtocol? = nil,
        eventService: EventService = EventService.shared,
        appState: AppState? = nil
    ) {
        self.coordinator = coordinator
        self.eventService = eventService
        self.appState = appState
    }
    
    // MARK: - Fetch Upcoming Events
    func fetchUpcomingEvents() async {
        
        guard upcomingEvents.isEmpty else { return }
        isLoading = true
        
        errorMessage = nil
        
        do {
            let events = try await eventService.getUpcomingEvents(limit: 5)
            
            self.upcomingEvents = events
            self.isLoading = false
            
        } catch let error as NetworkError {
            self.isLoading = false
            if upcomingEvents.isEmpty {
                errorMessage = error.localizedDescription
            }
        } catch {
            self.isLoading = false
            if upcomingEvents.isEmpty {
                errorMessage = "No events found"
            }
        }
    }
    
    // MARK: - Navigate to Event Details
    func viewEventDetails(eventId: Int) {
        coordinator?.goEventsDetails(id: eventId)
    }
    
    // MARK: - Navigate to Browse with Category
    func viewCategory(categoryName: String) {
        selectedCategoryName = categoryName
    }
    
    // MARK: - Navigate to all events
    func viewAllEvents() {
        coordinator?.goAllEventsPage()
    }
    
    func goBack() {
        coordinator?.pop()
    }
    
    
}
