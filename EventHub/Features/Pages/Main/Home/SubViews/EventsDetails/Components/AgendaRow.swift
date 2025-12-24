//
//  AgendaRow.swift
//  EventHub
//
//  Created by LILIANA on 12/25/25.
//
import SwiftUI

struct AgendaRow: View {
    let step: String
    let title: String
    let subtitle: String
    var isLast: Bool = false

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            VStack {
                Text(step)
                    .font(.caption)
                    .frame(width: 24, height: 24)
                    .background(Color.gray.opacity(0.2))
                    .clipShape(Circle())

                if !isLast {
                    Rectangle()
                        .fill(Color.gray.opacity(0.4))
                        .frame(width: 2, height: 30)
                        .padding(.top, 2)
                }
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}
