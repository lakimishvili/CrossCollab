//
//  CategoryViewModel.swift
//  EventHub
//
//  Created by Bacho on 25.12.25.
//


import Foundation

@MainActor
final class CategoryViewModel: ObservableObject {
    @Published var selectedCategory: String = "Conference"
    @Published var events: [EventListItem] = []
    @Published var isLoading: Bool = false
    
    let categoryMapping: [String: Int] = [
        "Conference": 1,
        "Workshop": 2,
        "Seminar": 3,
        "Networking": 4,
        "Party": 5
    ]
    
    var categories: [String] {
        Array(categoryMapping.keys).sorted()
    }
    private let eventService: EventService
    weak var coordinator: MainCoordinatorProtocol?
    
    init(eventService: EventService = .shared, coordinator: MainCoordinatorProtocol?) {
        self.eventService = eventService
        self.coordinator = coordinator
    }
    
    func selectCategory(_ category: String) async {
        selectedCategory = category
        await fetchEvents()
    }
    
    func fetchEvents() async {
        isLoading = true
        do {
            let selectedId = categoryMapping[selectedCategory]
            
            let filters = EventFilters(eventTypeId: selectedId)
            
            events = try await eventService.getEvents(filters: filters)
        } catch {
            print("Category fetch error: \(error)")
            events = []
        }
        isLoading = false
    }
    
    func viewDetails(id: Int) {
        coordinator?.goEventsDetails(id: id)
    }
}
