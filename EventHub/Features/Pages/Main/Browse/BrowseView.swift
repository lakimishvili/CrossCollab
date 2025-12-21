//
//  BrowseView.swift
//  EventHub
//
//  Created by Bacho on 22.12.25.
//

import SwiftUI

struct BrowseView: View {
    
    @StateObject var viewModel: BrowseViewModel
    
    var body: some View {
        Text("Browse")
    }
}

#Preview {
    BrowseView(viewModel: BrowseViewModel())
}
