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

private struct AppManagerKey {
    static let kEnvironmentConfig = "EnvironmentConfiguration"
}

/// AppManager class that initialise the sdk and cnfifure the environment
public struct AppManager {

    private static var currentEnvironment: EnvironmentDetail?

    public static var environment: EnvironmentDetail? {
        if currentEnvironment == nil {
            if let contentData = SecureStoreManager.getData(key: AppManagerKey.kEnvironmentConfig),
               let content = try? JSONDecoder().decode(EnvironmentDetail.self, from: contentData) {
                currentEnvironment = content
            }
        }
        return currentEnvironment
    }

    public static func configure(_ environment: EnvironmentDetail) {
        currentEnvironment = environment
        if let contentData = try? JSONEncoder().encode(currentEnvironment) {
            _ =  SecureStoreManager.delete(itemForKey: AppManagerKey.kEnvironmentConfig)
            _ = SecureStoreManager.set(data: contentData, forKey: AppManagerKey.kEnvironmentConfig)

        }
    }
}
