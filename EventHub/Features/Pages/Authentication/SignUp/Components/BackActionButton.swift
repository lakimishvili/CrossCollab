//
//  BackActionButton.swift
//  EventHub
//
//  Created by LILIANA on 12/22/25.
//

import SwiftUI

struct BackActionButton: View {
    
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: "arrow.left")
                Text(title)
            }
            .font(.system(size: 14, weight: .regular))
            .foregroundColor(Color("DarkBlack"))
        }
        .buttonStyle(.plain)
    }
}
