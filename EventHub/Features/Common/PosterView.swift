//
//  PosterView.swift
//  EventHub
//
//  Created by Bacho on 25.12.25.
//

import SwiftUI

struct PosterView: View {
    let imageURL: String?
    let size: CGFloat
    
    var body: some View {
        Group {
            if let urlString = imageURL,
               !urlString.isEmpty,
               let url = URL(string: urlString) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        loadingPlaceholder
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(height: size)
                            .clipped()
                    case .failure:
                        defaultImage
                    @unknown default:
                        defaultImage
                    }
                }
            } else {
                defaultImage
            }
        }
        .frame(height: size)
    }
}

// MARK: - Subviews
private extension PosterView {
    
    var loadingPlaceholder: some View {
        ZStack {
            Color.gray.opacity(0.1)
            ProgressView()
                .progressViewStyle(.circular)
        }
        .frame(height: size)
    }
    
    var defaultImage: some View {
        Image("defaultEvent")
            .resizable()
            .scaledToFill()
            .frame(height: size)
            .clipped()
    }
}
