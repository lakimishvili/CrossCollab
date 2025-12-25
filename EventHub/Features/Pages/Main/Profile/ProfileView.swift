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
        ZStack {
            Color(white: 0.95)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                Image("pfp")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .foregroundColor(.white)
                    .background(Circle().fill(Color.black))
                    .padding()
                
                VStack(spacing: 4) {
                    Text(viewModel.currentUserName ?? "Full Name")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                    
                    Text(viewModel.currentUserEmail ?? "email@example.com")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                Button {
                    viewModel.logout()
                } label: {
                    Text("Logout")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.black)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal, 40)
                .padding(.top, 10)
                .padding(.bottom, 20)
                
            }
            .background(Color.white)
            .cornerRadius(20)
            .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
            .padding(.horizontal, 40)
            .frame(maxWidth: 400)
        }
    }
}
