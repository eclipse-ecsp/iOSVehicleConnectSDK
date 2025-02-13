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

extension RemoteOperationServiceable {
    var roRepository: RemoteOperationRepositoryProtocol {
        get {
            return RORepositoryMock()
        }
        set {}
    }
}
final class ROServiceTests: XCTestCase {
    let vehicleId = "DOZWRTAJDT5163"
    let userEmail = "new_robot_user_1701242348@yopmail.com"

    override func setUp() {
        super.setUp()
        AuthManager.shared.authProtocol.accessToken = accessToken
        AuthManager.shared.authProtocol.tokenType = tokenType
    }

    
    func testGetROHistory() async {
       
        let repository:RemoteOperationRepositoryProtocol = RORepositoryMock()
        var service =  RemoteOperationService()
        service.roRepository = repository
        let roRequest = RemoteOperationHistoryRequest(userId: userEmail, vehicleId: vehicleId)
        let result = await service.getROHistory(roRequest)
        switch result {
        case .success(let vehicle):
            XCTAssertNotNil(vehicle.model.first?.roEvent.eventId)
        case .failure:
            XCTFail("Service repository GetROHistory Failed")
        }
    }
        
    func testGetRORequest() async {
            let repository:RemoteOperationRepositoryProtocol = RORepositoryMock()
            var service = RemoteOperationService()
            service.roRepository = repository
            let roRequest = RemoteEventStatusRequest(userId: userEmail, vehicleId: vehicleId, reuestId: "FvJ434N5mL6aialtesMuTow2hg10YnW1")
            let result = await service.getRORequest(roRequest)
            switch result {
            case .success(let vehicle):
                XCTAssertNotNil(vehicle.model.roEvent.eventId)
            case .failure:
                XCTFail("Service repository GetROStatus request is failed")
            }
        }
    
        func testSetRORequest() async {
            let repository:RemoteOperationRepositoryProtocol = RORepositoryMock()
            var service = RemoteOperationService()
            service.roRepository = repository
            let data = RemoteEventUpdateData(state: .started, percent: 20, duration: 8)
            let roRequest = RemoteEventUpdateRequest(userId: userEmail, vehicleId: vehicleId, stateType: .engine, postData: data)
            let result = await service.setRORequest(roRequest)
            switch result {
            case .success(let vehicle):
                XCTAssertNotNil(vehicle.model.requestId ?? "empty")
            case .failure:
                XCTFail("Service repository SetRORequest is failed")
            }
        }
    }
    


final class RORepositoryMock: RemoteOperationRepositoryProtocol {

    func getROHistory(_ request: RemoteOperationHistoryRequest) async ->
    Result<Response<[RemoteEventHistory]>, CustomError> {
        let dataMock = DataMock()
        let result = dataMock.readData(fromFile: "roHistory")
        return await Helper.decoded(result, [RemoteEventHistory].self)
    }

    func getROCommandRequest(_ request: RemoteEventStatusRequest) async ->
    Result<Response<RemoteEventHistory>, CustomError> {
        let dataMock = DataMock()
        let result = dataMock.readData(fromFile: "roEventStatus")
        return await Helper.decoded(result, RemoteEventHistory.self)
    }

    func setROCommandRequest(_ request: RemoteEventUpdateRequest) async ->
    Result<Response<RemoteEventRequestStatus>, CustomError> {
        let dataMock = DataMock()
        let result = dataMock.readData(fromFile: "roEventUpdate")
        return await Helper.decoded(result, RemoteEventRequestStatus.self)
    }

}


