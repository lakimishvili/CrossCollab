//
//  BrowseHeaderView.swift
//  EventHub
//
//  Created by LILIANA on 12/23/25.
//

import SwiftUI

struct BrowseHeaderView: View {

    var body: some View {
        HStack {
            Text("Browse Events")
                .font(.title2.bold())
                .foregroundColor(.black)

            Spacer()

            Image(systemName: "calendar")
                .font(.title3)
                .foregroundColor(.black)
        }
        .padding()
        .background(Color("customWhite"))
    }
}
