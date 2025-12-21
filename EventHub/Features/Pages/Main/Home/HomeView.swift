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
        Text("Home")
    }
}

#Preview {
    HomeView(viewModel: HomeViewModel())
}
