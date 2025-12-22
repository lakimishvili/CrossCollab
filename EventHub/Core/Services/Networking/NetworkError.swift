//
//  NetworkError.swift
//  EventHub
//
//  Created by Bacho on 22.12.25.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case decodingFailed
    case serverError(Int)
    case unauthorized
    
    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid server response"
        case .decodingFailed:
            return "Failed to decode data"
        case .serverError(let code):
            return "Server error: \(code)"
        case .unauthorized:
            return "Please login again"
        }
    }
}
