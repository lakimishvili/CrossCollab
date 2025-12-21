//
//  NotificationsView.swift
//  EventHub
//
//  Created by Bacho on 22.12.25.
//

import SwiftUI

struct NotificationsView: View {
    
    @StateObject var viewModel: NotificationsViewModel
    
    var body: some View {
        Text("Notifications")
    }
}

#Preview {
    NotificationsView(viewModel: NotificationsViewModel())
}
