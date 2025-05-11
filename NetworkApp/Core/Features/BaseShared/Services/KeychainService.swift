//
//  KeychainManager.swift
//  NetworkApp
//
//  Created by Ivan Behichev on 25.04.2025.
//

import Foundation
import Security

final class KeychainService: SecureStorable {
    
    func save<T: Codable>(_ object: T, forKey key: String) {
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(object) else { return }
        
        let query: [String: Any] = [
            kSecClass as String       : kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String  : data
        ]
        
        SecItemDelete(query as CFDictionary)
        let _ = SecItemAdd(query as CFDictionary, nil)
    }
    
    func get<T: Codable>(forKey key: String, as type: T.Type) -> T? {
        let query: [String: Any] = [
            kSecClass as String       : kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String : true,
            kSecMatchLimit as String : kSecMatchLimitOne
        ]
        
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        guard status == errSecSuccess,
              let data = dataTypeRef as? Data else {
            return nil
        }
        
        let decoder = JSONDecoder()
        return try? decoder.decode(type, from: data)
    }
    
    func delete(forKey key: String) {
        let query: [String: Any] = [
            kSecClass as String       : kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]
        SecItemDelete(query as CFDictionary)
    }
}
