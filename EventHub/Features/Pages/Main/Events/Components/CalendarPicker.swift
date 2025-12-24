//
//  CalendarPicker.swift
//  EventHub
//
//  Created by Bacho on 24.12.25.
//

import SwiftUI


struct CalendarPicker: View {
    @Binding var selectedDate: Date
    
    var body: some View {
        DatePicker(
            "",
            selection: $selectedDate,
            displayedComponents: [.date]
        )
        .datePickerStyle(.graphical)
    }
}
