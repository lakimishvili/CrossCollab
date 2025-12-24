//
//  TabBarButton.swift
//  EventHub
//
//  Created by Bacho on 03.12.25.
//

import SwiftUI

struct TabBarButton: View {
    
    var buttonText: String
    var imageName: String
    var isActive: Bool
    var scale: CGFloat
    
    var body: some View {
        VStack(spacing: 8) {
            Image(imageName)
                .resizable()
                .renderingMode(.template)
                .scaledToFill()
                .frame(width: 18, height: 18)
                .scaleEffect(scale)
                .foregroundStyle(isActive ? .primary : .secondary)
            
            Text(buttonText)
                .font(.system(size: 12, weight: .regular))
                .foregroundStyle(isActive ? .primary : .secondary)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    TabBarButton(
        buttonText: "Profile",
        imageName: "profile",
        isActive: true,
        scale: 1.0
    )
    .frame(width: 100, height: 60)
}
