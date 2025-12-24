//
//  NextEventCard.swift
//  EventHub
//
//  Created by Bacho on 24.12.25.
//

import SwiftUI
import MapKit


struct NextEventCard: View {
    let event: Event
    @State private var showingMapAlert = false
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 41.7151, longitude: 44.8271),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    
    var body: some View {
        VStack(spacing: 12) {
            Text(event.title)
                .font(.headline)
            
            Label(formatDateTime(event.startDateTime), systemImage: "calendar")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Label(event.location, systemImage: "location")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            // Map
            ZStack {
                Map(coordinateRegion: $region, interactionModes: [])
                    .frame(height: 160)
                    .cornerRadius(14)
                
                Button(action: { showingMapAlert = true }) {
                    Color.clear
                }
                .frame(height: 160)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 6)
        .padding(.horizontal)
        .alert("Open in Maps?", isPresented: $showingMapAlert) {
            Button("Apple Maps") { openInAppleMaps() }
            Button("Google Maps") { openInGoogleMaps() }
            Button("Cancel", role: .cancel) {}
        }
    }
    
    private func formatDateTime(_ dateString: String) -> String {
        let components = dateString.split(separator: "-")
        guard components.count >= 3 else { return "TBA" }
        let month = components[1]
        let day = components[2].split(separator: "T")[0]
        return "\(month)/\(day)"
    }
    
    private func openInAppleMaps() {
        let query = event.location.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        if let url = URL(string: "http://maps.apple.com/?q=\(query)") {
            UIApplication.shared.open(url)
        }
    }
    
    private func openInGoogleMaps() {
        let query = event.location.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        if let url = URL(string: "comgooglemaps://?q=\(query)"),
           UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        } else if let url = URL(string: "https://maps.google.com/?q=\(query)") {
            UIApplication.shared.open(url)
        }
    }
}

