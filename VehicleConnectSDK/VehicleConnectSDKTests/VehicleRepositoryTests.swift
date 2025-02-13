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


final class VehicleRepositoryTests: XCTestCase {

    override func setUp() {
        super.setUp()
        }
    
    func testAssociatedVehiclesSuccess() async {
        
        let hettpClient: HTTPClientMock =  HTTPClientMock()
        hettpClient.testCaseType = .testGetAssociatedVehiclesSuccess
        var repository = VehicleRepository()
        repository.client = hettpClient
        let result  = await repository.getAssociatedVehicles()
        switch result {
        case .success(let vehicle):
            XCTAssertNotNil(vehicle.model.vehiclesList?.first?.deviceId, "empty")
        case .failure:
            XCTFail("The request is failed")
        }
    }
    
    func testVehicleProfileSuccess() async {
        let hettpClient: HTTPClientMock =  HTTPClientMock()
        hettpClient.testCaseType = .testGetVehicleProfileSuccess
        var repository = VehicleRepository()
        repository.client = hettpClient
        let request = VehicleProfileRequest(vehicleId: "60b0bed7ccb3c0786a603b80")
        let result = await repository.getVehicleProfile(request: request)
        switch result {
        case .success(let vehicle):
            XCTAssertNotNil(vehicle.model.data?.first?.id ?? "empty")
        case .failure:
            XCTFail("The request is failed")
        }
    }
    
    func testValidateIMEISuccess() async {
        let hettpClient: HTTPClientMock =  HTTPClientMock()
        hettpClient.testCaseType = .testValidateImeiSuccess
        var repository = VehicleRepository()
        repository.client = hettpClient
        let request = ValidateImeiRequest(imei: "167253671257915273")
        let result = await repository.validateIMEI(request)
        switch result {
        case .success(let vehicle):
            XCTAssertNotNil(vehicle.model.first?.imei ?? "empty")
        case .failure:
            XCTFail("The request is failed")
        }
    }
    
    func testAddDeviceSuccess() async {
        let hettpClient: HTTPClientMock =  HTTPClientMock()
        hettpClient.testCaseType = .testAddDeviceSuccess
        var repository = VehicleRepository()
        repository.client = hettpClient
        let request = AssociateRequest(imei: "167253671257915273")
        let result = await repository.addDevice(request)
        switch result {
        case .success(let vehicle):
            XCTAssertNotNil(vehicle.model.associationId ?? "empty")
        case .failure:
            XCTFail("The request is failed")
        }
    }
        
    func testRemoveDeviceSuccess() async {
        let hettpClient: HTTPClientMock =  HTTPClientMock()
        hettpClient.testCaseType = .testRemoveDeviceSuccess
        var repository = VehicleRepository()
        repository.client = hettpClient
        let request = TerminateRequest(imei: "167253671257915273")
            let result = await repository.removeDevice(request)
            switch result {
            case .success(let vehicle):
                XCTAssertNotNil(vehicle.model.code)
            case .failure:
                XCTFail("The request is failed")
            }
        }
    
    func testUpdateVehicleSuccess() async {
        let hettpClient: HTTPClientMock =  HTTPClientMock()
        hettpClient.testCaseType = .testUpdateVehicleProfileSuccess
        var repository = VehicleRepository()
        repository.client = hettpClient
        let attributes = Attributes(vehicleAttributes: VehicleAttribute(name: "my car"))
        let request = UpdateProfileRequest(vehicleId: "DOZWRTAJDT5163", params: attributes)
            let result = await repository.updateVehicleProfile(request)
            switch result {
            case .success(let vehicle):
                XCTAssertNotNil(vehicle.model.data)
            case .failure:
                XCTFail("The request is failed")
            }
        }
    
    func testAssociatedVehiclesFailed() async {
        
        let hettpClient: HTTPClientMock =  HTTPClientMock()
        hettpClient.testCaseType = .testGetAssociatedVehicleFailed
        var repository = VehicleRepository()
        repository.client = hettpClient
        let result  = await repository.getAssociatedVehicles()
        switch result {
        case .success:
            XCTFail("AssociatedVehicles test is failed because this is request failed case")
        case .failure(let error):
            XCTAssertNotNil(error)
        }
    }
    
    func testVehicleProfileFailed() async {
        let hettpClient: HTTPClientMock =  HTTPClientMock()
        hettpClient.testCaseType = .testGetVehicleProfileFailed
        var repository = VehicleRepository()
        repository.client = hettpClient
        let request = VehicleProfileRequest(vehicleId: "60b0bed7ccb3c0786a603b80")
        let result = await repository.getVehicleProfile(request: request)
        switch result {
        case .success:
            XCTFail("VehicleProfile test is failed because this is request failed case")
        case .failure(let error):
            XCTAssertNotNil(error)
        }
    }
    
    func testValidateIMEIFailed() async {
        let hettpClient: HTTPClientMock =  HTTPClientMock()
        hettpClient.testCaseType = .testValidateIMEIFailed
        var repository = VehicleRepository()
        repository.client = hettpClient
        let request = ValidateImeiRequest(imei: "167253671257915273")
        let result = await repository.validateIMEI(request)
        switch result {
        case .success:
            XCTFail("ValidateIMEI test is failed because this is request failed case")
        case .failure(let error):
            XCTAssertNotNil(error)
        }
    }
    
    func testAddDeviceFailed() async {
        let hettpClient: HTTPClientMock =  HTTPClientMock()
        hettpClient.testCaseType = .testAddDeviceFailed
        var repository = VehicleRepository()
        repository.client = hettpClient
        let request = AssociateRequest(imei: "167253671257915273")
        let result = await repository.addDevice(request)
        switch result {
        case .success:
            XCTFail("AddDevice test is failed because this is request failed case")
        case .failure(let error):
            XCTAssertNotNil(error)
        }
    }
        
    func testRemoveDeviceFailed() async {
        let hettpClient: HTTPClientMock =  HTTPClientMock()
        hettpClient.testCaseType = .testRemoveDeviceFailed
        var repository = VehicleRepository()
        repository.client = hettpClient
        let request = AssociateRequest(imei: "167253671257915273")
            let result = await repository.addDevice(request)
            switch result {
            case .success:
                XCTFail("RemoveDevice test is failed because this is request failed case")
            case .failure(let error):
                XCTAssertNotNil(error)
            }
        }
    
    func testUpdateVehicleFailed() async {
        let hettpClient: HTTPClientMock =  HTTPClientMock()
        hettpClient.testCaseType = .testUpdateVehicleProfileFailed
        var repository = VehicleRepository()
        repository.client = hettpClient
        let attributes = Attributes(vehicleAttributes: VehicleAttribute(name: "my car"))
        let request = UpdateProfileRequest(vehicleId: "DOZWRTAJDT5163", params: attributes)
            let result = await repository.updateVehicleProfile(request)
            switch result {
            case .success:
                XCTFail("UpdateVehicle test is failed because this is request failed case")
            case .failure(let error):
                XCTAssertNotNil(error)
            }
        }
}

