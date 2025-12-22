//
//  KeychainManager.swift
//  EventHub
//
//  Created by Bacho on 22.12.25.
//

import Foundation
import Security

final class KeychainManager {
    static let shared = KeychainManager()
    
    private init() {}
    
    // MARK: - Keys
    private enum Keys {
        static let authToken = "com.eventhub.authToken"
        static let userId = "com.eventhub.userId"
        static let userRole = "com.eventhub.userRole"
    }
    
    // MARK: - Save Token
    func saveToken(_ token: String) -> Bool {
        return save(key: Keys.authToken, value: token)
    }
    
    // MARK: - Load Token
    func loadToken() -> String? {
        return load(key: Keys.authToken)
    }
    
    // MARK: - Delete Token
    func deleteToken() -> Bool {
        return delete(key: Keys.authToken)
    }
    
    // MARK: - Save User Info
    func saveUserId(_ userId: Int) -> Bool {
        return save(key: Keys.userId, value: "\(userId)")
    }
    
    func loadUserId() -> Int? {
        guard let value = load(key: Keys.userId) else { return nil }
        return Int(value)
    }
    
    func saveUserRole(_ role: String) -> Bool {
        return save(key: Keys.userRole, value: role)
    }
    
    func loadUserRole() -> String? {
        return load(key: Keys.userRole)
    }
    
    // MARK: - Clear All (Logout)
    func clearAll() -> Bool {
        let tokenDeleted = deleteToken()
        let userIdDeleted = delete(key: Keys.userId)
        let roleDeleted = delete(key: Keys.userRole)
        
        return tokenDeleted && userIdDeleted && roleDeleted
    }
    
    // MARK: - Private Helpers
    
    private func save(key: String, value: String) -> Bool {
        guard let data = value.data(using: .utf8) else { return false }
        
        _ = delete(key: key)
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data,
            kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlock
        ]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        return status == errSecSuccess
    }
    
    private func load(key: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        guard status == errSecSuccess,
              let data = result as? Data,
              let string = String(data: data, encoding: .utf8) else {
            return nil
        }
        
        return string
    }
    
    private func delete(key: String) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        return status == errSecSuccess || status == errSecItemNotFound
    }
}

extension KeychainManager {
    var isLoggedIn: Bool {
        return loadToken() != nil
    }
    
    var currentUserId: Int? {
        return loadUserId()
    }
    
    var currentUserRole: String? {
        return loadUserRole()
    }
}
