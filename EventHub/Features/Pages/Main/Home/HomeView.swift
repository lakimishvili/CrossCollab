//
//  HomeView.swift
//  EventHub
//
//  Created by Bacho on 22.12.25.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject var viewModel: HomeViewModel
    @State private var showProfile = false
    @State private var showCategoryBrowse  = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                headerSection
                upcomingEventsSection
                categoriesSection
                trendingSection
                faqSection
            }
            .padding(.horizontal)
            .padding(.bottom, 24)
        }
        .background(Color("customWhite"))
        .task {
            if viewModel.upcomingEvents.isEmpty {
                await viewModel.fetchUpcomingEvents()
            }
        }
        .refreshable {
            if viewModel.upcomingEvents.isEmpty {
                await viewModel.fetchUpcomingEvents()
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showProfile) {
            viewModel.coordinator?.makeProfileView()
        }
        
        .sheet(isPresented: $showCategoryBrowse) {
            NavigationStack {
                BrowseView(viewModel: {
                    let vm = BrowseViewModel(coordinator: viewModel.coordinator)
                    vm.initialCategory = viewModel.selectedCategoryName
                    return vm
                }())
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Done") {
                            showCategoryBrowse = false
                        }
                    }
                }
            }
        }
    }
}

private extension HomeView {
    
    var headerSection: some View {
        VStack(spacing: 16) {
            VStack {
                HStack(spacing: 8) {
                    Image(systemName: "square.fill")
                        .resizable()
                        .frame(width: 28, height: 28)
                        .cornerRadius(6)
                    
                    Text("EventHub")
                        .font(.headline)
                    
                    Spacer()
                    
                    HStack(spacing: 16) {
                        Image(systemName: viewModel.hasUnread ? "bell.badge" : "bell")
                            .font(.title3)
                        
                        Image("pfp")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .onTapGesture {
                                showProfile.toggle()
                            }
                    }
                    .font(.title3)
                }
                .padding(.vertical, 12)
                
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 1)
            }
            .background(Color.white)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Welcome back, \(viewModel.userName)")
                    .font(.title2.bold())
                
                Text("Stay connected with upcoming company events and activities.")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
    }
}

private extension HomeView {
    
    var upcomingEventsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            HStack {
                Text("Upcoming Events")
                    .fontWeight(.regular)
                
                Spacer()
                Text("View all")
                    .font(.subheadline)
                    .foregroundColor(.blue)
                
                    .onTapGesture {
                        viewModel.viewAllEvents()
                    }
            }
            
            if viewModel.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity)
                    .padding()
            }
            
            else if let errorMessage = viewModel.errorMessage {
                VStack(spacing: 12) {
                    Text(errorMessage)
                        .font(.subheadline)
                        .foregroundColor(.red)
                    
                }
                .frame(maxWidth: .infinity)
                .padding()
            }
            
            else if viewModel.upcomingEvents.isEmpty {
                Text("No upcoming events")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity)
                    .padding()
            }
            
            else {
                VStack(spacing: 12) {
                    ForEach(viewModel.upcomingEvents.prefix(3)) { event in
                        EventCardView(
                            date: DateHelper.formatEventDate(event.startDateTime),
                            title: event.title,
                            time: DateHelper.formatEventTime(event.startDateTime),
                            location: event.locationString,
                            footer: DateHelper.formatEventFooter(event),
                            isDisabled: event.isFull
                        )
                        .onTapGesture {
                            viewModel.viewEventDetails(eventId: event.id)
                        }
                    }
                }
            }
        }
    }

}

private extension HomeView {
    
    var categoriesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Browse by Category")
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 12) {
                CategoryItem(icon: "categoryTeam", title: "Team Building", count: "12 events")
                    .onTapGesture {
                        viewModel.viewCategory(categoryName: "Team Building")
                        showCategoryBrowse = true
                    }
                
                CategoryItem(icon: "categorySport", title: "Sports", count: "8 events")
                    .onTapGesture {
                        viewModel.viewCategory(categoryName: "Sports")
                        showCategoryBrowse = true
                    }
                
                CategoryItem(icon: "categoryWorkshop", title: "Workshops", count: "18 events")
                    .onTapGesture {
                        viewModel.viewCategory(categoryName: "Workshop")  
                        showCategoryBrowse = true
                    }
                
                CategoryItem(icon: "categoryHappyFridays", title: "Happy Fridays", count: "4 events")
                    .onTapGesture {
                        viewModel.viewCategory(categoryName: "Happy Friday")
                        showCategoryBrowse = true
                    }
                
                CategoryItem(icon: "categoryCulture", title: "Cultural", count: "6 events")
                    .onTapGesture {
                        viewModel.viewCategory(categoryName: "Cultural")
                        showCategoryBrowse = true
                    }
                
                CategoryItem(icon: "categoryWellness", title: "Wellness", count: "9 events")
                    .onTapGesture {
                        viewModel.viewCategory(categoryName: "Training")
                        showCategoryBrowse = true
                    }
            }
        }
    }
}

private extension HomeView {
    
    var trendingSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Trending Events")
            
            Text("Popular events with high registration rates.")
                .font(.caption)
                .foregroundColor(.gray)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(viewModel.upcomingEvents.prefix(2)) { event in
                        TrendingCard(
                            title: event.title,
                            date: DateHelper.formatDate(event.startDateTime, format: "MMM dd, yyyy"),
                            image: event.imageUrl ?? "",
                            size: 120
                        )
                        .onTapGesture {
                            viewModel.viewEventDetails(eventId: event.id)
                        }
                    }
                }
            }
        }
    }
}

private extension HomeView {
    
    var faqSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Frequently Asked Questions")
            
            VStack(alignment: .leading, spacing: 6) {
                Text("What if I need to cancel?")
                
                Text("You can cancel your registration up to 24 hours before the event through this app. This will allow someone from the waitlist to attend.")
                    .font(.caption)
                    .foregroundColor(.black).opacity(0.8)
            }
        }
    }
}

#Preview {
    HomeView(viewModel: HomeViewModel())
}
