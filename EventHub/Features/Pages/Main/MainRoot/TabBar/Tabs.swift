//
//  Tabs.swift
//  RickNMorty
//
//  Created by Bacho on 03.12.25.
//


import SwiftUI

enum Tabs: Int {
    case home = 0
    case browse = 1
    case events = 2
    case notifications = 3
    case profile = 4
}

struct TabItem {
    let imageName: String
    let buttonText: String
    let type: Tabs
}
