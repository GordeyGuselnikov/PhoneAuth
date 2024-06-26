//
//  KeychainService.swift
//  PhoneAuth
//
//  Created by Guselnikov Gordey on 25.06.24.
//

import Security
import Foundation

class KeychainManager {
    
    @discardableResult
    static func save(key: String, value: String) -> OSStatus {
        let data = value.data(using: .utf8)!
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecValueData: data
        ] as CFDictionary
        SecItemDelete(query) // Удалить существующий элемент перед добавлением нового
        return SecItemAdd(query, nil)
    }
    
    static func load(key: String) -> String? {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecReturnData: kCFBooleanTrue!,
            kSecMatchLimit: kSecMatchLimitOne
        ] as CFDictionary
        
        var dataTypeRef: AnyObject? = nil
        let status = SecItemCopyMatching(query, &dataTypeRef)
        guard status == errSecSuccess else { return nil }
        
        guard let data = dataTypeRef as? Data else { return nil }
        return String(data: data, encoding: .utf8)
    }
    
    @discardableResult
    static func delete(key: String) -> OSStatus {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key
        ] as CFDictionary
        return SecItemDelete(query)
    }
    
    static func isAuthorizedWithAppCode(_ code: String) -> Bool {
        if let savedCode = load(key: "appCode"), savedCode == code {
            return true
        } else {
            return false
        }
    }
}

