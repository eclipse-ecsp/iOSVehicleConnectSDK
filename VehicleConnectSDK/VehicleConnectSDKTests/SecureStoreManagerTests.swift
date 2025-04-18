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

final class SecureStoreManagerTests: XCTestCase {
    
    func testSetData() throws {
        let userData = DataMock().getJsonData(fromFile: "userProfile" , ext: "json")
        if let contentData = try? JSONEncoder().encode(userData) {
            let dataSuccess = SecureStoreManager.set(contentData, forKey: "profile")
            if dataSuccess{
                XCTAssertTrue(dataSuccess)
            }else{
                XCTFail("Set data test is failed")
            }
        }
    }
    
    
    func testSetDictionary() throws {
        let dictionary = ["testId":"123","testName":"secureDictTest"]
        let dataSuccess = SecureStoreManager.set(dictionary, forKey: "testDict")
        if dataSuccess{
            XCTAssertTrue(dataSuccess)
        }else{
            XCTFail("Set dictionary test is failed")
        }
    }
    
    func testGetDictionary() throws {
        let key = "testDict"
        let dictionary = ["testId":"123","testName":"secureDictTest"]
        _ = SecureStoreManager.set(dictionary, forKey: "testDict")
        let fetchedDict  = SecureStoreManager.get(forKey: key, as: [String: String].self)
        XCTAssertNotNil(fetchedDict)
    }
    
    func testSetString() throws {
        let string = "secureText"
        let dataSuccess = SecureStoreManager.set(string, forKey: "testString")
        if dataSuccess{
            XCTAssertTrue(dataSuccess)
        }else{
            XCTFail("Set string test is failed")
        }
    }
    
    func testGetString() throws {
        let fetchedString  = SecureStoreManager.get(forKey: "testString", as: String.self)
        if let fetchedString {
            XCTAssertNotNil(fetchedString)
        }
        else{
            XCTFail("get string test is failed")
        }
    }
    
    
    
    func testSetDeleteData() throws {
        let userData = DataMock().getJsonData(fromFile: "userProfile" , ext: "json")
        if let contentData = try? JSONEncoder().encode(userData) {
            let dataSuccess = SecureStoreManager.set(contentData, forKey: "testdata")
            if dataSuccess{
                XCTAssertTrue(dataSuccess)
            }else{
                XCTFail("Set delete data test is failed")
            }
        }
    }
    
    func testDeleteItemForkey () throws {
        let string = "secureText"
        _ = SecureStoreManager.set(string, forKey: "testString")
        let itemDeleteSuccess = SecureStoreManager.delete(forKey: "testString")
        if itemDeleteSuccess{
            XCTAssertTrue(itemDeleteSuccess)
        }else{
            XCTFail("Set data test is failed")
        }
    }
}

