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

final class NotificationRepositoryTests: XCTestCase {
    
    override func setUp()  {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    func testShareDeviceTokenSuccess() async {
        
        let token = "ef91gKoNWUPMvy0Xd6wt48:APA91bFWt_jxTFNRAHpDLtcp7Q7Dme7avwiqgDmZ2AnfKo3wjE3GylmE4fJobK8PnoUecL-JzEM5hvzu3sQDuGe-Ew0BCPbrypAQ8V8UmPzqA6BKCGKVfl8zhQtZUKeAf2OMPBx-IuIb"
        let channel = Channel(appPlatform: "iOS", type: "push", enabled: true, deviceTokens: [token], service: "apns")
        let data = ChannelData(group: "all", channels: [channel], enabled: true)
        let request = DeviceTokenRequest(vehicleId: "DOWHGWGA262496", userId: "new_robot_user_1707297004@yopmail.com", postData: [data])
        let hettpClient: HTTPClientMock =  HTTPClientMock()
        hettpClient.testCaseType = .testShareDeviceTokenSuccess
        var repositorySut = NotificationRepository()
        repositorySut.client = hettpClient
        let result = await repositorySut.shareDeviceToken(request)
        switch result {
        case .success:
            XCTFail("The test is failed because this apidoes not return data")
        case .failure(let error):
            // in case of decode erroe test case is passed as this api does not return any data
            XCTAssertEqual(error.message == "decode", false)
            
        }
    }
    
    func testGetNotificationHistorySuccess() async {
        let vehicleId = "DOWHGWGA262496"
        let gregorian = Calendar(identifier: .gregorian)
        let startDate: Date? =  gregorian.date(byAdding: .day, value: -7, to: Date())
        let till = String(Int64((Date().timeIntervalSince1970 * 1000.0).rounded()))
        let from = String(Int64((startDate!.timeIntervalSince1970 * 1000.0).rounded()))
        let data = QueryData(from: from, till: till, alertType: "GenericNotificationEvent", readStatus: "all", page: 1, size: 100)
        let request = NotificationRequest(vehicleId: vehicleId, query: data)
        let hettpClient: HTTPClientMock =  HTTPClientMock()
        hettpClient.testCaseType = .testGetAlertsHistorySuccess
        var repositorySut = NotificationRepository()
        repositorySut.client = hettpClient
        let result = await repositorySut.getAlerts(request)
        switch result {
        case .success(let alerts):
            XCTAssertNotNil(alerts.model.alerts)
        case .failure:
            XCTFail("The getNotificationHistory is failed")
        }
    }
    
    func testShareDeviceTokenFailed() async {
        let token = "ef91gKoNWUPMvy0Xd6wt48:APA91bFWt_jxTFNRAHpDLtcp7Q7Dme7avwiqgDmZ2AnfKo3wjE3GylmE4fJobK8PnoUecL-JzEM5hvzu3sQDuGe-Ew0BCPbrypAQ8V8UmPzqA6BKCGKVfl8zhQtZUKeAf2OMPBx-IuIb"
        let channel = Channel(appPlatform: "iOS", type: "push", enabled: true, deviceTokens: [token], service: "apns")
        let data = ChannelData(group: "all", channels: [channel], enabled: true)
        let request = DeviceTokenRequest(vehicleId: "DOWHGWGA262496", userId: "new_robot_user_1707297004@yopmail.com", postData: [data])
        let hettpClient: HTTPClientMock =  HTTPClientMock()
        hettpClient.testCaseType = .testShareDeviceTokenFailed
        var repositorySut = NotificationRepository()
        repositorySut.client = hettpClient
        let result = await repositorySut.shareDeviceToken(request)
        switch result {
        case .success:
            XCTFail("ShareDeviceToken test is failed because this is request failed case")
        case .failure(let error):
            // in case of decode erroe test case is passed as this api does not return any data
            XCTAssertEqual(error.message == "decode", false)
        }
    }
    
    func testGetNotificationHistoryFailed() async {
        let vehicleId = "DOWHGWGA262496"
        let gregorian = Calendar(identifier: .gregorian)
        let startDate: Date? =  gregorian.date(byAdding: .day, value: -7, to: Date())
        let till = String(Int64((Date().timeIntervalSince1970 * 1000.0).rounded()))
        let from = String(Int64((startDate!.timeIntervalSince1970 * 1000.0).rounded()))
        let data = QueryData(from: from, till: till, alertType: "GenericNotificationEvent", readStatus: "all", page: 1, size: 100)
        let request = NotificationRequest(vehicleId: vehicleId, query: data)
        let hettpClient: HTTPClientMock =  HTTPClientMock()
        hettpClient.testCaseType = .testGetAlertsHistoryFailed
        let repositorySut = NotificationRepository()
        let result = await repositorySut.getAlerts(request)
        switch result {
        case .success:
            XCTFail("GetNotificationHistory test is failed because this is reqquest failed case")
        case .failure(let error):
            XCTAssertNotNil(error)
        }
    }
}



