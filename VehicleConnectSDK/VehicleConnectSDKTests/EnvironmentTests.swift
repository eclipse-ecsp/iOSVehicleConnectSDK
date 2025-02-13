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

import XCTest

@testable import VehicleConnectSDK
final class EnvironmentTests: XCTestCase {
    
    var getEnvironments: [EnvironmentDetail] {
           let bundle = Bundle.allBundles.first(where: { $0.bundlePath.hasSuffix(".xctest") })!
            guard let path = bundle.url(forResource: "environment", withExtension: "json") else {
                fatalError("Failed to load JSON")
            }
            do {
                let data = try Data(contentsOf: path)
                let decodedObject = try JSONDecoder().decode([EnvironmentDetail].self, from: data)
                return decodedObject
            } catch {
                fatalError("Failed to decode loaded JSON")
            }
    }
    
    func testEnvironmentSetup() {
        if let environment = getEnvironments.first {
            AppManager.configure(environment)
            if let item = AppManager.environment {
                XCTAssertNotNil(item.baseUrl)
                
            }
            else {
                XCTFail("Environment setup is failed")
            }
        }
        else {
            XCTFail("Environment setup is failed")
        }
    }
    
    
    func testUrlValidation() {
        let url = "https://localhost:8080/v1.0/vehicleProfiles?vehicleId=628e1ebc03501653e83df4b1"
        XCTAssertTrue(url.isValidURL)
    }
}
