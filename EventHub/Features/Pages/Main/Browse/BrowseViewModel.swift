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
        print("📞 fetchEventTypes() called...")
        
        do {
            let types = try await eventService.getEventTypes()
            
            print("📦 Received \(types.count) types from service: \(types.map { $0.name })")
            
            await MainActor.run {
                self.eventTypes = [EventType(id: 0, name: "All", description: nil)] + types
                
                print("📋 Final eventTypes array: \(self.eventTypes.map { $0.name })")
            }
            
            if let initial = initialCategory {
                print("🎯 Looking for initialCategory: '\(initial)'")
                
                let index = eventTypes.firstIndex { eventType in
                    eventType.name.lowercased() == initial.lowercased()
                }
                
                if let index = index {
                    await MainActor.run {
                        self.selectedCategoryIndex = index
                        print("✅ Selected category at index \(index): \(self.eventTypes[index].name)")
                    }
                } else {
                    print("⚠️ Category '\(initial)' not found in: \(self.eventTypes.map { $0.name })")
                }
            }
            
        } catch {
            print("❌ fetchEventTypes error: \(error)")
            
            // ✅ Fallback categories
            await MainActor.run {
                self.eventTypes = [
                    EventType(id: 0, name: "All", description: nil),
                    EventType(id: 1, name: "Workshop", description: nil),
                    EventType(id: 2, name: "Team Building", description: nil),
                    EventType(id: 3, name: "Sports", description: nil),
                    EventType(id: 4, name: "Happy Friday", description: nil),
                    EventType(id: 5, name: "Cultural", description: nil),
                    EventType(id: 6, name: "Training", description: nil)
                ]
                print("⚠️ Using fallback categories: \(self.eventTypes.map { $0.name })")
            }
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
        print("🔄 applyFilters() called - selectedCategoryIndex: \(selectedCategoryIndex)")
        
        errorMessage = nil
        
        Task {
            await fetchEventsWithFilter()
        }
    }
    
    private func fetchEventsWithFilter() async {
        isLoading = true
        errorMessage = nil
        
        print("🔍 Applying filters...")
        print("   - Category index: \(selectedCategoryIndex)")
        print("   - Search text: '\(searchText)'")
        print("   - Only available: \(onlyAvailable)")
        
        do {
            var filters = EventFilters()
            
            if selectedCategoryIndex > 0, selectedCategoryIndex < eventTypes.count {
                let selectedType = eventTypes[selectedCategoryIndex]
                filters.eventTypeId = selectedType.id
                print("   ✅ Filter by eventTypeId: \(selectedType.id) (\(selectedType.name))")
            } else {
                print("   ℹ️ Showing all categories")
            }
            
            if !searchText.isEmpty {
                filters.searchKeyword = searchText
                print("   ✅ Filter by keyword: '\(searchText)'")
            }
            
            if onlyAvailable {
                filters.onlyAvailable = true
                print("   ✅ Filter only available")
            }
            
            let filteredEvents = try await eventService.getEvents(filters: filters)
            
            await MainActor.run {
                self.events = filteredEvents
                self.isLoading = false
                print("✅ Filtered result: \(filteredEvents.count) events")
                if !filteredEvents.isEmpty {
                    print("   Events: \(filteredEvents.map { $0.title })")
                }
            }
            
        } catch let error as NetworkError {
            await MainActor.run {
                self.isLoading = false
                self.errorMessage = error.localizedDescription
                print("❌ Filter failed: \(error.localizedDescription)")
            }
        } catch {
            await MainActor.run {
                self.isLoading = false
                self.errorMessage = "Failed to filter events"
                print("❌ Filter failed: \(error)")
            }
        }
    }
    
    // MARK: - Navigate to Event Details
    func viewEventDetails(eventId: Int) {
        coordinator?.goEventsDetails(id: eventId)
    }
}
