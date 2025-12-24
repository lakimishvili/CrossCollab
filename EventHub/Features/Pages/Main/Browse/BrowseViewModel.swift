//
//  BrowseViewModel.swift
//  EventHub
//
//  Created by Bacho on 22.12.25.
//

import Combine

@MainActor
final class BrowseViewModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published var events: [EventListItem] = []
    @Published var eventTypes: [EventType] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    // MARK: - Filter Properties
    @Published var searchText: String = "" {
        didSet {
            applyFilters()
        }
    }
    @Published var selectedCategoryIndex: Int = 0 {
        didSet {
            applyFilters()
        }
    }
    @Published var onlyAvailable: Bool = false {
        didSet {
            applyFilters()
        }
    }
    
    // MARK: - Dependencies
    weak var coordinator: MainCoordinatorProtocol?
    private let eventService: EventService
    
    // MARK: - Init
    init(
        coordinator: MainCoordinatorProtocol? = nil,
        eventService: EventService = EventService.shared
    ) {
        self.coordinator = coordinator
        self.eventService = eventService
    }
    
    // MARK: - Fetch Event Types
    func fetchEventTypes() {
        Task {
            do {
                let types = try await eventService.getEventTypes()
                
                await MainActor.run {
                    self.eventTypes = [EventType(id: 0, name: "All", description: nil)] + types
                }
                
            } catch {
                print("Failed to fetch event types: \(error)")
            }
        }
    }
    
    // MARK: - Fetch Events
    func fetchEvents() {
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let events = try await eventService.getEvents(filters: nil)
                
                await MainActor.run {
                    self.events = events
                    self.isLoading = false
                }
                
            } catch let error as NetworkError {
                await MainActor.run {
                    self.isLoading = false
                    self.errorMessage = error.localizedDescription
                }
            } catch {
                await MainActor.run {
                    self.isLoading = false
                    self.errorMessage = "Failed to load events"
                }
            }
        }
    }
    
    // MARK: - Apply Filters
    private func applyFilters() {
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                // Build filters
                var filters = EventFilters()
                
                // Category filter (if not "All")
                if selectedCategoryIndex > 0, selectedCategoryIndex < eventTypes.count {
                    filters.eventTypeId = eventTypes[selectedCategoryIndex].id
                }
                
                // Search filter
                if !searchText.isEmpty {
                    filters.searchKeyword = searchText
                }
                
                // Availability filter
                if onlyAvailable {
                    filters.onlyAvailable = true
                }
                
                // Fetch with filters
                let filteredEvents = try await eventService.getEvents(filters: filters)
                
                await MainActor.run {
                    self.events = filteredEvents
                    self.isLoading = false
                }
                
            } catch let error as NetworkError {
                await MainActor.run {
                    self.isLoading = false
                    self.errorMessage = error.localizedDescription
                }
            } catch {
                await MainActor.run {
                    self.isLoading = false
                    self.errorMessage = "Failed to filter events"
                }
            }
        }
    }
    
    // MARK: - Navigate to Event Details
    func viewEventDetails(eventId: Int) {
        // TODO: Navigate to event details when implemented
        print("Navigate to event \(eventId)")
    }
}
