//
//  SpeakerRow.swift
//  EventHub
//
//  Created by LILIANA on 12/25/25.
//

import SwiftUI

struct SpeakerRow: View {
    let name: String
    let role: String
    let imageName: String

    var body: some View {
        HStack(spacing: 12) {

            Image(imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 40, height: 40)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.gray.opacity(0.3), lineWidth: 1))
                .shadow(radius: 1)

            VStack(alignment: .leading) {
                Text(name)
                    .font(.subheadline)
                Text(role)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
}
