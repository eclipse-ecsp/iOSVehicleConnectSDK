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

/// Structure for starage manager for storing, retriving and update secure information
struct SecureStoreManager {

    private static var lock = os_unfair_lock_s()

    static func set(data: Data, forKey key: String) -> Bool {
        if getData(key: key) != nil {
            let isSuccessfulUpdate = self.update(data: data, forKey: key)
            return isSuccessfulUpdate
        } else {
            let isSuccesful = self.add(data: data, forKey: key)
            return isSuccesful
        }
    }

    static func set(dictionary: [String: Any], forKey key: String) -> Bool {
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: dictionary, requiringSecureCoding: false)
            let isSuccessful = self.set(data: data, forKey: key)
            return isSuccessful
        } catch { }
        return false
    }

    static func set(string: String, forKey key: String) -> Bool {
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: string, requiringSecureCoding: false)
            let isSuccessful = set(data: data, forKey: key)
            return isSuccessful
        } catch {
        }
        return false
    }

    static func getData(key myKey: String) -> Data? {
        let requestAttributes: [String: Any] = [
            String(kSecClass): kSecClassGenericPassword,
            String(kSecAttrAccount): myKey,
            String(kSecReturnData): kCFBooleanTrue ?? false,
            String(kSecMatchLimit): kSecMatchLimitOne
        ]
        var result: AnyObject?
        _ = SecItemCopyMatching(requestAttributes as CFDictionary, &result)

        return result as? Data
    }

    static func getDictionary(key myKey: String) -> [String: Any]? {
        guard let data = getData(key: myKey) else { return nil }
        guard let dict = try? NSKeyedUnarchiver.unarchivedObject(ofClass: NSDictionary.self, from: data)
                as? [String: Any] else { return nil }
        return dict
    }

    static func getString(key myKey: String) -> String? {
        guard let data = getData(key: myKey) else { return nil }
        guard let str = try? NSKeyedUnarchiver.unarchivedObject(ofClass: NSString.self, from: data)
                as? String else { return nil }
        return str
    }

    static func delete(itemForKey key: String) -> Bool {
        let result = self.sync {
            let deleteAttributes: [String: Any] = [
                String(kSecClass): kSecClassGenericPassword,
                String(kSecAttrAccount): key
            ]

            let deleteItemResult = SecItemDelete(deleteAttributes as CFDictionary)
            return deleteItemResult == noErr
        }
        return result
    }

    private static func add(data: Data, forKey key: String) -> Bool {
        let result = self.sync {
            let attributes: [String: Any] = [
                String(kSecClass): kSecClassGenericPassword,
                String(kSecAttrAccount): key,
                String(kSecValueData): data,
                String(kSecAttrAccessible): kSecAttrAccessibleWhenUnlockedThisDeviceOnly
            ]

            let addItemResult = SecItemAdd(attributes as CFDictionary, nil)
            return addItemResult == noErr
        }
        return result
    }

    private static func update(data newData: Data, forKey key: String) -> Bool {
        let result = self.sync {
            let oldAttributesByKey: [String: Any] = [
                String(kSecClass): kSecClassGenericPassword,
                String(kSecAttrAccount): key
            ]
            let attributesToUpdate: [String: Any] = [
                String(kSecValueData): newData
            ]

            let updateItemResult = SecItemUpdate(oldAttributesByKey as CFDictionary, attributesToUpdate as CFDictionary)
            return updateItemResult == noErr
        }
        return result
    }

    private static func sync(execute: () -> Bool) -> Bool {
        os_unfair_lock_lock(&lock)
        let result = execute()
        print("operation successful: " + (result ? "true" : "false"))
        os_unfair_lock_unlock(&lock)
        return result
    }

    func decodeData<T: Decodable>(raw data: Data, withType type: T.Type, processComplete:
                                  @escaping(_ model: T?, _ error: Error?) -> Void) {
        do {
            let model = try JSONDecoder().decode(T.self, from: data)
            processComplete(model, nil) } catch let error {
                processComplete(nil, error)
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
