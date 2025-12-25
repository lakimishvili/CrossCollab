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
    
    private let service = "com.eventhub.app"
    private let tokenKey = "com.eventhub.authToken"
    private let userIdKey = "com.eventhub.userId"
    private let userRoleKey = "com.eventhub.userRole"
    private let userNameKey = "com.eventhub.userName"
    
    // MARK: - Token
    func saveToken(_ token: String) -> Bool {
        return save(key: tokenKey, value: token)
    }
    
    func loadToken() -> String? {
        return load(key: tokenKey)
    }
    
    func deleteToken() -> Bool {
        return delete(key: tokenKey)
    }
    
    // MARK: - User ID
    func saveUserId(_ userId: Int) -> Bool {
        return save(key: userIdKey, value: "\(userId)")
    }
    
    func loadUserId() -> Int? {
        guard let value = load(key: userIdKey) else { return nil }
        return Int(value)
    }
    
    // MARK: - User Role
    func saveUserRole(_ role: String) -> Bool {
        return save(key: userRoleKey, value: role)
    }
    
    func loadUserRole() -> String? {
        return load(key: userRoleKey)
    }
    
    // MARK: - User Name (NEW!)
    func saveUserName(_ name: String) -> Bool {
        return save(key: userNameKey, value: name)
    }
    
    func loadUserName() -> String? {
        return load(key: userNameKey)
    }
    
    // MARK: - Clear All
    func clearAll() -> Bool {
        let results = [
            deleteToken(),
            delete(key: userIdKey),
            delete(key: userRoleKey),
            delete(key: userNameKey)
        ]
        return results.allSatisfy { $0 }
    }
    
    // MARK: - Convenience Properties
    var isLoggedIn: Bool {
        return loadToken() != nil
    }
    
    var currentUserId: Int? {
        return loadUserId()
    }
    
    var currentUserRole: String? {
        return loadUserRole()
    }
    
    var currentUserName: String? {
        return loadUserName()
    }
    
    // MARK: - Private Helpers
    private func save(key: String, value: String) -> Bool {
        let data = Data(value.utf8)
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data,
            kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlock
        ]
        
        SecItemDelete(query as CFDictionary)
        
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
              let value = String(data: data, encoding: .utf8) else {
            return nil
        }
        
        return value
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
