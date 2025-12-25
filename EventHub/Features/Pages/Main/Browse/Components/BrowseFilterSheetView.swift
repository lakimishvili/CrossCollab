//
//  BrowseFilterSheetView.swift
//  EventHub
//
//  Created by LILIANA on 12/23/25.
//

import SwiftUI

struct BrowseFilterSheetView: View {
    
    @Binding var isPresented: Bool
    
    @State private var selectedCategory: String = "All"
    @State private var location: String = ""
    @State private var startDate: Date = Date()
    @State private var endDate: Date = Date()
    @State private var minCapacity: Int = 0
    @State private var maxCapacity: Int = 100
    
    let categories = [
        "All",
        "Team Building",
        "Sports",
        "Workshop",
        "Happy Friday",
        "Cultural",
        "Training",
        "Social"
    ]
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                
                VStack(alignment: .leading, spacing: 6) {
                    Text("Category")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Picker("Category", selection: $selectedCategory) {
                        ForEach(categories, id: \.self) { category in
                            Text(category).tag(category)
                        }
                    }
                    .pickerStyle(.menu)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                }
                
                VStack(alignment: .leading, spacing: 6) {
                    Text("Location")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    TextField("Enter location", text: $location)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                }
                
                VStack(alignment: .leading, spacing: 6) {
                    Text("Date Range")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    VStack {
                        DatePicker("From", selection: $startDate, displayedComponents: .date)
                        DatePicker("To", selection: $endDate, displayedComponents: .date)
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                }
                
                VStack(alignment: .leading, spacing: 6) {
                    Text("Capacity")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    HStack {
                        TextField("Min", value: $minCapacity, format: .number)
                            .keyboardType(.numberPad)
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                        TextField("Max", value: $maxCapacity, format: .number)
                            .keyboardType(.numberPad)
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                    }
                }
                
                Spacer()
                
                Button {
                    isPresented = false
                } label: {
                    Text("Apply Filters")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                
            }
            .padding()
            .navigationTitle("Filter Events")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        isPresented = false
                    }
                }
            }
        }
    }
}
