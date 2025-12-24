//
//  InfoRow.swift
//  EventHub
//
//  Created by LILIANA on 12/25/25.
//

import SwiftUI


struct InfoRow: View {
    let icon: String
    let text: String

    var body: some View {
        HStack(alignment: .center, spacing: 8) {

            Image(systemName: icon)
                .font(.footnote)
                .foregroundColor(.black.opacity(0.7))
                .frame(width: 16)

            Text(text)
                .font(.subheadline)
                .foregroundColor(.black.opacity(0.7))
            Spacer()
        }
    }
}
