//
//  HomeView.swift
//  EventHub
//
//  Created by Bacho on 22.12.25.
//
import SwiftUI

struct HomeView: View {
    
    @StateObject var viewModel: HomeViewModel
    
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
                        Image(systemName: "bell")
                        Image(systemName: "person.crop.circle")
                    }
                    .font(.title3)
                }
                .padding(.vertical, 12)
                
                // Bottom border
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 1)
            }
            .background(Color.white)
            
            // MARK: - Greeting Section (NO white background)
            VStack(alignment: .leading, spacing: 4) {
                Text("Welcome back, Sarah")
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
            }
            
            VStack(spacing: 12) {
                EventCardView(
                    date: "JAN\n18",
                    title: "Annual Team Building Summit",
                    time: "08:00 AM - 05:00 PM",
                    location: "Grand Conference Hall",
                    footer: "102 registered • 8 spots left"
                )
                
                EventCardView(
                    date: "JAN\n20",
                    title: "Leadership Workshop",
                    time: "02:00 PM - 04:30 PM",
                    location: "Training Room B",
                    footer: "28 registered • 2 spots left"
                )
                
                EventCardView(
                    date: "JAN\n24",
                    title: "Happy Friday: Game Night",
                    time: "06:00 PM - 09:00 PM",
                    location: "Recreation Lounge",
                    footer: "30 registered • Full",
                    isDisabled: true
                )
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
                CategoryItem(icon: "categorySport", title: "Sports", count: "8 events")
                CategoryItem(icon: "categoryWorkshop", title: "Workshops", count: "18 events")
                CategoryItem(icon: "categoryHappyFridays", title: "Happy Fridays", count: "4 events")
                CategoryItem(icon: "categoryCulture", title: "Cultural", count: "6 events")
                CategoryItem(icon: "categoryWellness", title: "Wellness", count: "9 events")
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
                    TrendingCard(
                        title: "Tech Talk: AI in Business",
                        date: "Jan 26, 2025"
                    )

                    TrendingCard(
                        title: "Annual Hackathon",
                        date: "Feb 02, 2025"
                    )

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
