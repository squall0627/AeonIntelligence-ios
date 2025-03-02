//
//  AuthManager.swift
//  AeonIntelligence
//
//  Created by 陳浩 on 2025/02/25.
//

import Foundation
import Security

class AuthManager {
    static let shared = AuthManager()

    private let tokenKey = "auth_token"
//    private let baseURLKey = "base_url"

    private init() {}

    // MARK: - Token Management

    var token: String? {
        get {
            return getFromKeychain(key: tokenKey)
        }
        set {
            if let newValue = newValue {
                saveToKeychain(key: tokenKey, value: newValue)
            } else {
                removeFromKeychain(key: tokenKey)
            }
        }
    }

//    var baseURL: String? {
//        get {
//            return getFromKeychain(key: baseURLKey)
//        }
//        set {
//            if let newValue = newValue {
//                saveToKeychain(key: baseURLKey, value: newValue)
//            } else {
//                removeFromKeychain(key: baseURLKey)
//            }
//        }
//    }

    var isAuthenticated: Bool {
        return token != nil
    }

//    // Create API client with current auth info
//    func createAPIClient() -> APIClient? {
//        guard let token = token, let baseURL = baseURL else {
//            return nil
//        }
//        return APIClient(baseURL: baseURL, token: token)
//    }

    // Clear all auth data
    func clearAuth() {
        token = nil
//        baseURL = nil
    }

    // MARK: - Keychain Operations

    private func saveToKeychain(key: String, value: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: value.data(using: .utf8)!,
            kSecAttrAccessible as String:
                kSecAttrAccessibleWhenUnlockedThisDeviceOnly,
        ]

        // First try to delete any existing item
        SecItemDelete(query as CFDictionary)

        // Then add the new item
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else {
            print("Error saving to Keychain: \(status)")
            return
        }
    }

    private func getFromKeychain(key: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne,
        ]

        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)

        guard status == errSecSuccess,
            let data = dataTypeRef as? Data,
            let value = String(data: data, encoding: .utf8)
        else {
            return nil
        }

        return value
    }

    private func removeFromKeychain(key: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
        ]

        SecItemDelete(query as CFDictionary)
    }
}
