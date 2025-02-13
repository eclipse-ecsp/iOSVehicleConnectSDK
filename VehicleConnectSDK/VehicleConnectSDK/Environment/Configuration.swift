//
//  Configuration.swift
//  VehicleOEMDigitalKey
//
//  Created by Kumar, Vishwajeet on 16/01/24.
//

import Foundation

struct Configuration {
    static var environment: Environment? {
        if let contentData = SecureStoreManager.shared.getData(key: kEnvironmentConfig),
            let content = try? JSONDecoder().decode(Environment.self, from: contentData) {
            return content
        }
        return nil
    }

    static var accessToken: String {
        if IgniteAuthManager.shared.igniteAuthProtocol.accessToken.isEmpty {
            return SecureStoreManager.shared.getString(key: kAccessToken) ?? ""
        }
        return IgniteAuthManager.shared.igniteAuthProtocol.accessToken
    }
}
