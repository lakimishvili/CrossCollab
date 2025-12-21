//
//  EventsView.swift
//  EventHub
//
//  Created by Bacho on 22.12.25.
//

import SwiftUI

struct EventsView: View {
    
    @StateObject var viewModel: EventsViewModel
    
    var body: some View {
        Text("Events")
    }
}

#Preview {
    EventsView(viewModel: EventsViewModel())
}
