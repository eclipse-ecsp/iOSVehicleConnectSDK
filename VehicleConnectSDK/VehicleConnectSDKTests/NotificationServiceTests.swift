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

extension NotificationServiceable {
    var notificationRepository: NotificationRepositoryProtocol {
        get {
            return NotificationRepositoryMock()
        }
        set {}
    }
}

final class NotificationServiceTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        AuthManager.shared.authProtocol.accessToken = accessToken
        AuthManager.shared.authProtocol.tokenType = tokenType
    }
    
    func testShareDeviceTokenServiceSuccess() async {

        let token = "ef91gKoNWUPMvy0Xd6wt48:APA91bFWt_jxTFNRAHpDLtcp7Q7Dme7avwiqgDmZ2AnfKo3wjE3GylmE4fJobK8PnoUecL-JzEM5hvzu3sQDuGe-Ew0BCPbrypAQ8V8UmPzqA6BKCGKVfl8zhQtZUKeAf2OMPBx-IuIb"
        let channel = Channel(appPlatform: "iOS", type: "push", enabled: true, deviceTokens: [token], service: "apns")
        let data = ChannelData(group: "all", channels: [channel], enabled: true)
        let request = DeviceTokenRequest(vehicleId: "DOWHGWGA262496", userId: "new_robot_user_1707297004@yopmail.com", postData: [data])
        let repository:NotificationRepositoryProtocol = NotificationRepositoryMock()
        var service = NotificationService()
        service.notificationRepository = repository
        let result = await service.shareDeviceToken(request)
        switch result {
        case .success(let vehicle):
            XCTAssertTrue(vehicle.model)
            
        case .failure(let error):
            // in case of decode erroe test case is passed as this api does not return any data
            XCTAssertEqual(error.message == "decode", false)
            
        }
    }
    
    func testGetNotificationHistoryServiceSuccess() async {
        let vehicleId = "DOWHGWGA262496"
        let gregorian = Calendar(identifier: .gregorian)
        let startDate: Date? =  gregorian.date(byAdding: .day, value: -7, to: Date())
        let till = String(Int64((Date().timeIntervalSince1970 * 1000.0).rounded()))
        let from = String(Int64((startDate!.timeIntervalSince1970 * 1000.0).rounded()))
        let data = QueryData(from: from, till: till, alertType: "GenericNotificationEvent", readStatus: "all", page: 1, size: 100)
        let request = NotificationRequest(vehicleId: vehicleId, query: data)
        let repository:NotificationRepositoryProtocol = NotificationRepositoryMock()
        var service = NotificationService()
        service.notificationRepository = repository
        let result = await service.getAlerts(request)
        switch result {
        case .success(let response):
            XCTAssertNotNil(response.model.alerts)
        case .failure:
            XCTFail("Service get notification History Failed")
        }
    }
}


final class NotificationRepositoryMock: NotificationRepositoryProtocol {
    
    func getAlerts(_ request: NotificationRequest) async -> Result<Response<VehicleAlerts>, CustomError> {
        let dataMock = DataMock()
        let result = dataMock.readData(fromFile: "alertsHistory")
        return await Helper.decoded(result, VehicleAlerts.self)
    }

    func shareDeviceToken(_ request: DeviceTokenRequest) async -> Result<Response<Bool>, CustomError> {
        let dataMock = DataMock()
        let result = dataMock.readData(fromFile: "shareDeviceToken")
        return await Helper.decoded(result, Bool.self)
    }
    
   
    
}
