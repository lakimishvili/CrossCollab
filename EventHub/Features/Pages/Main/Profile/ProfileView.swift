//
//  ProfileView.swift
//  EventHub
//
//  Created by Bacho on 22.12.25.
//

import SwiftUI

struct ProfileView: View {
    @StateObject var viewModel: ProfileViewModel
    
    var body: some View {
        VStack {
            Text("Profile")
                .font(.largeTitle)
            
            Button("Logout") {
                viewModel.logout()
            }
            .padding()
            .background(Color.red)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
    }
}

#Preview {
    ProfileView(viewModel: ProfileViewModel())
}
