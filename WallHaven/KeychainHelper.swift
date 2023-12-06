//
//  KeychainHelper.swift
//  WallHaven
//
//  Created by Raeein Bagheri on 2023-12-05.
//

import Foundation
import Security

class KeychainHelper {
    
    static let service = "com.raeeinbagheri.WallHaven"
    static let account = "api-key"
    
    static func storeData(data: Data, forService service: String, account: String) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecValueData as String: data
        ]
        
        let status = SecItemAdd (query as CFDictionary, nil)
        
        if status == errSecDuplicateItem {
            print("Key already exists")
        }
        return status == errSecSuccess
    }
}
