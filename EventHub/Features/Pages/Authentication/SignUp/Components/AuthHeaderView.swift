//
//  AuthHeaderView.swift
//  EventHub
//
//  Created by LILIANA on 12/22/25.
//

import SwiftUI

struct AuthHeaderView: View {
    
    let title: String
    let subtitle: String
    
    var body: some View {
        VStack(spacing: 20) {
            Text(title)
                .font(.system(size: 36, weight: .regular))
            
            Text(subtitle)
                .font(.system(size: 14))
                .foregroundColor(Color("LightGray"))
                .multilineTextAlignment(.center)
        }
    }
}
