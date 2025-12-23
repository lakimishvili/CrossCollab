//
//  EventSearchView.swift
//  EventHub
//
//  Created by LILIANA on 12/23/25.
//
import SwiftUI

struct EventSearchView: View {

    @Binding var text: String
    @State private var showFilterSheet = false

    var body: some View {
        VStack(spacing: 0) {

            HStack(spacing: 12) {
                HStack(spacing: 6) {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)

                    TextField("Search events...", text: $text)
                        .font(.subheadline)
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 8)
                .background(Color.gray.opacity(0.12))
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Color.gray.opacity(0.35), lineWidth: 1)
                )
                .cornerRadius(6)

                Button {
                    showFilterSheet.toggle()
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "slider.horizontal.3")
                        Text("Filter")
                            .font(.subheadline)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .foregroundColor(.black)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(Color.gray.opacity(0.35), lineWidth: 1)
                    )
                }
                .sheet(isPresented: $showFilterSheet) {
                    BrowseFilterSheetView(isPresented: $showFilterSheet)
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
            .background(Color("customWhite"))

            Divider()
                .background(Color.gray.opacity(0.3))
        }
    }
}
