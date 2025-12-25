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
    
    var initialCategory: String?
    
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
    func fetchEventTypes() async {
        do {
            let types = try await eventService.getEventTypes()
            
            self.eventTypes = [EventType(id: 0, name: "All", description: nil)] + types
            
            if let initial = initialCategory,
               let index = eventTypes.firstIndex(where: { $0.name == initial }) {
                self.selectedCategoryIndex = index
            }
            
        } catch {
            print("Failed to fetch event types: \(error)")
        }  
    }
    
    // MARK: - Fetch Events
    func fetchEvents() async {
        isLoading = true
        errorMessage = nil
        
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
    
    // MARK: - Apply Filters
    private func applyFilters() {
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                var filters = EventFilters()
                
                if selectedCategoryIndex > 0, selectedCategoryIndex < eventTypes.count {
                    filters.eventTypeId = eventTypes[selectedCategoryIndex].id
                }
                
                if !searchText.isEmpty {
                    filters.searchKeyword = searchText
                }
                
                if onlyAvailable {
                    filters.onlyAvailable = true
                }
                
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
        coordinator?.goEventsDetails(id: eventId)
    }
}
