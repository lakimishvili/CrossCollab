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
        isLoading = true
        errorMessage = nil
        
        do {
            let events = try await eventService.getUpcomingEvents(limit: 5)
            upcomingEvents = events
            isLoading = false

        } catch let error as NetworkError {
            isLoading = false
            errorMessage = error.localizedDescription
            
        } catch {
            isLoading = false
            errorMessage = "Failed to load events"
        }
    }
    
    // MARK: - Navigate to Event Details
    func viewEventDetails(eventId: Int) {
        coordinator?.goEventsDetails(id: eventId)
    }
    
    // MARK: - Navigate to Browse with Category
    func viewCategory(categoryName: String) {
        // TODO: Navigate to Browse with filter
        print("View category: \(categoryName)")
    }
    
    // MARK: - Navigate to all events
    func viewAllEvents() {
        coordinator?.goAllEventsPage()
    }
}
