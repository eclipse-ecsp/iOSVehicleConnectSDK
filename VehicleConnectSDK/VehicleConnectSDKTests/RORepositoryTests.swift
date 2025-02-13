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




final class RORepositoryTests: XCTestCase {
    let vehicleId = "DOZWRTAJDT5163"
    let userEmail = "new_robot_user_1701242348@yopmail.com"
    override func setUp() {
        super.setUp()
        AuthManager.shared.authProtocol.accessToken = accessToken
        AuthManager.shared.authProtocol.tokenType = tokenType
    }
    
    func testRepositoryGetROHistorySuccess() async {
        let hettpClient: HTTPClientMock =  HTTPClientMock()
        hettpClient.testCaseType = .testGetROHistorySuccess
        var repository = RemoteOperationRepository()
        repository.client = hettpClient
        let roRequest = RemoteOperationHistoryRequest(userId: userEmail, vehicleId: vehicleId)
        let result = await repository.getROHistory(roRequest)
        switch result {
        case .success(let vehicle):
            XCTAssertNotNil(vehicle.model.first?.roEvent.eventId)
        case .failure:
            XCTFail("Service repository GetROHistory failed")
        }
    }
        
    func testRepositoryGetRORequestSuccess() async {
            let hettpClient: HTTPClientMock =  HTTPClientMock()
            hettpClient.testCaseType = .testGetROCommandSuccess
            var repository = RemoteOperationRepository()
            repository.client = hettpClient
            let roRequest = RemoteEventStatusRequest(userId: userEmail, vehicleId: vehicleId, reuestId: "FvJ434N5mL6aialtesMuTow2hg10YnW1")
            let result = await repository.getROCommandRequest(roRequest)
            switch result {
            case .success(let vehicle):
                XCTAssertNotNil(vehicle.model.roEvent.eventId)
            case .failure:
                XCTFail("Service repository GetRORequest is failed")
            }
        }
    
        func testRepositorySetRORequestSuccess() async {
            let hettpClient: HTTPClientMock =  HTTPClientMock()
            hettpClient.testCaseType = .testSetROCommandSuccess
            var repository = RemoteOperationRepository()
            repository.client = hettpClient
            let data = RemoteEventUpdateData(state: .started, percent: 20, duration: 8)
            let roRequest = RemoteEventUpdateRequest(userId: userEmail, vehicleId: vehicleId, stateType: .engine, postData: data)
            let result = await repository.setROCommandRequest(roRequest)
            switch result {
            case .success(let vehicle):
                XCTAssertNotNil(vehicle.model.requestId ?? "empty")
            case .failure:
                XCTFail("Service repository SetRORequest is failed")
            }
        }
    func testRepositoryGetROHistoryFailed() async {
        let hettpClient: HTTPClientMock =  HTTPClientMock()
        hettpClient.testCaseType = .testGetROHistoryFailed
        var repository = RemoteOperationRepository()
        repository.client = hettpClient
        let roRequest = RemoteOperationHistoryRequest(userId: userEmail, vehicleId: vehicleId)
        let result = await repository.getROHistory(roRequest)
        switch result {
        case .success:
            XCTFail("Service repository GetROHistory test is failed as this is failed case")
        case .failure(let error):
            XCTAssertNotNil(error)
        }
    }
        
    func testRepositoryGetRORequestFailed() async {
            let hettpClient: HTTPClientMock =  HTTPClientMock()
            hettpClient.testCaseType = .testGetROCommandFailed
            var repository = RemoteOperationRepository()
            repository.client = hettpClient
            let roRequest = RemoteEventStatusRequest(userId: userEmail, vehicleId: vehicleId, reuestId: "FvJ434N5mL6aialtesMuTow2hg10YnW1")
            let result = await repository.getROCommandRequest(roRequest)
            switch result {
            case .success:
                XCTFail("Service repository GetRORequest test is failed as this is failed case")
            case .failure(let error):
                XCTAssertNotNil(error)
            }
        }
    
        func testRepositorySetRORequestFailed() async {
            let hettpClient: HTTPClientMock =  HTTPClientMock()
            hettpClient.testCaseType = .testSetROCommandFailed
            var repository = RemoteOperationRepository()
            repository.client = hettpClient
            let data = RemoteEventUpdateData(state: .started, percent: 20, duration: 8)
            let roRequest = RemoteEventUpdateRequest(userId: userEmail, vehicleId: vehicleId, stateType: .engine, postData: data)
            let result = await repository.setROCommandRequest(roRequest)
            switch result {
            case .success:
                XCTFail("Service repository SetROHistory test is failed as this is failed case")
            case .failure(let error):
                XCTAssertNotNil(error)
            }
        }
}
    
