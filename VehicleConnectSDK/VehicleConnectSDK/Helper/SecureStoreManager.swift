/********************************************************************************
 * Copyright (c) 2023-24 Harman International
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 * SPDX-License-Identifier: Apache-2.0
 ********************************************************************************/

import Foundation
import Security
import os.lock

/// Structure for starage manager for storing, retriving and update secure information
struct SecureStoreManager {

    private static let queue = DispatchQueue(label: "com.app.SecureStoreManager.lock")

    // MARK: - Set Codable object to Keychain
    static func set<T: Codable>(_ value: T, forKey key: String) -> Bool {
        do {
            let data = try JSONEncoder().encode(value)
            return store(data: data, forKey: key)
        } catch {
            print("Encoding error: \(error)")
            return false
        }
    }

    // MARK: - Get Codable object from Keychain
    static func get<T: Codable>(forKey key: String, as type: T.Type) -> T? {
        guard let data = getData(forKey: key) else { return nil }
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            print("Decoding error: \(error)")
            return nil
        }
    }

    // MARK: - Delete from Keychain
    static func delete(forKey key: String) -> Bool {
        return sync {
            let query: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrAccount as String: key
            ]
            return SecItemDelete(query as CFDictionary) == errSecSuccess
        }
    }

    // MARK: - Store or update data
    private static func store(data: Data, forKey key: String) -> Bool {
        if getData(forKey: key) != nil {
            return update(data: data, forKey: key)
        } else {
            return add(data: data, forKey: key)
        }
    }

    // MARK: - Add to Keychain
    private static func add(data: Data, forKey key: String) -> Bool {
        return sync {
            let query: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrAccount as String: key,
                kSecValueData as String: data,
                kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlockedThisDeviceOnly
            ]
            return SecItemAdd(query as CFDictionary, nil) == errSecSuccess
        }
    }

    // MARK: - Update Keychain item
    private static func update(data: Data, forKey key: String) -> Bool {
        return sync {
            let query: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrAccount as String: key
            ]
            let attributes: [String: Any] = [
                kSecValueData as String: data
            ]
            return SecItemUpdate(query as CFDictionary, attributes as CFDictionary) == errSecSuccess
        }
    }

    // MARK: - Get raw Data from Keychain
    static func getData(forKey key: String) -> Data? {
        var result: AnyObject?
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        SecItemCopyMatching(query as CFDictionary, &result)
        return result as? Data
    }

    // MARK: - Thread safety
    private static func sync(_ execute: () -> Bool) -> Bool {
        return queue.sync {
            execute()
        }
    }
}

extension SecureStoreManager {
    static var isFreshInstall: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "freshinstall")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "freshinstall")
        }
    }
}

// let _ = SecureStoreManager.set("my_secure_token_123", forKey: "authToken")
// let token: String? = SecureStoreManager.get(forKey: "authToken", as: String.self)

//// Set user
// struct User: Codable {
//    let name: String
//    let email: String
// }
//
// let user = User(name: "Alice", email: "alice@example.com")
// let _ = SecureStoreManager.set(user, forKey: "currentUser")
//
//// Get user
// if let user: User = SecureStoreManager.get(forKey: "currentUser", as: User.self) {
//    print(user.name)
// }
