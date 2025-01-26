//
//  KeychainManager.swift
//  AuthDemo
//
//  Created by Keyur Patel on 25/01/25.
//

import Security
import Foundation

class KeychainHelper {
    
    static let shared = KeychainHelper()
    
    // Save data to Keychain
    func saveToKeychain(key: KeychainKeys, value: String) {
        let data = value.data(using: .utf8)!
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key.rawValue,
            kSecValueData as String: data
        ]
        
        // Delete any existing data first
        SecItemDelete(query as CFDictionary)
        
        // Add the new item to the Keychain
        let status = SecItemAdd(query as CFDictionary, nil)
        
        if status != errSecSuccess {
            print("Error saving to Keychain: \(status)")
        }
    }
    
    // Retrieve data from Keychain
    func retrieveFromKeychain(key: KeychainKeys) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key.rawValue,
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        if status == errSecSuccess, let data = result as? Data, let value = String(data: data, encoding: .utf8) {
            return value
        } else {
            print("Error retrieving from Keychain: \(status)")
            return nil
        }
    }
    
    // Delete data from Keychain
    func deleteFromKeychain(key: KeychainKeys) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key.rawValue
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        
        if status != errSecSuccess {
            print("Error deleting from Keychain: \(status)")
        }
    }
}

enum KeychainKeys: String {
    case isUserLoggedIn
}
