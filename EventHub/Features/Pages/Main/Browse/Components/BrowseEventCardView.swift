//
//  BrowseEventCardView.swift
//  EventHub
//
//  Created by LILIANA on 12/23/25.
//

import SwiftUI

struct BrowseEventCardView: View {

    let month: String
    let day: String

    let category: String
    let title: String
    let time: String
    let location: String

    let registeredText: String
    let spotsText: String?
    let statusText: String
    let isDisabled: Bool

    var body: some View {
        HStack(alignment: .top, spacing: 12) {

            VStack(spacing: 2) {
                Text(month)
                    .font(.caption)
                    .foregroundColor(.gray)

                Text(day)
                    .font(.title3)
                    .foregroundColor(.black)
            }
            .frame(width: 44)

            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 6) {
                    Text(category)
                        .font(.caption2)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.gray.opacity(0.15))
                        .clipShape(Capsule())

                    Spacer()

                    Text(statusText)
                        .font(.caption2)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.gray.opacity(0.15))
                        .clipShape(Capsule())
                }

                Text(title)
                    .foregroundColor(.black)

                VStack(alignment: .leading, spacing: 6) {
                    Label(time, systemImage: "clock")
                    Label(location, systemImage: "location.fill")
                }
                .font(.caption)
                .foregroundColor(.gray)

                HStack(spacing: 12) {

                    Label(registeredText, systemImage: "person.3.fill")
                        .font(.caption2)
                        .foregroundColor(.gray)

                    if let spotsText {
                        Label(spotsText, systemImage: "chair.fill")
                            .font(.caption2)
                            .foregroundColor(.gray)
                    }

                    Spacer()
                }
            }
        }
        .padding(12)
        .background(Color.white)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.gray.opacity(0.3))
        )
        .cornerRadius(10)
        .opacity(isDisabled ? 0.5 : 1)
    }
}
