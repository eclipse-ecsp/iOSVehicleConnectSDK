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

extension VehicleServiceable {
    var vehicleRepository: VehicleRepositoryProtocol {
        get {
            return VehicleRepositoryMock()
        }
        set {}
    }
}

final class VehicleServiceTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        AuthManager.shared.authProtocol.accessToken = accessToken
        AuthManager.shared.authProtocol.tokenType = tokenType
    }
    
    func testAssociatedVehicles() async {
        
        let repository:VehicleRepositoryProtocol = VehicleRepositoryMock()
        var service =  VehicleService()
        service.vehicleRepository = repository
        let result = await service.getAssociatedVehicles()
        switch result {
        case .success(let vehicle):
            XCTAssertNotNil(vehicle.model.vehiclesList?.first?.deviceId)
        case .failure:
            XCTFail("Service getassociations failed")
        }
    }
    
    func testVehicleProfile() async {
        let repository:VehicleRepositoryProtocol = VehicleRepositoryMock()
        var service =  VehicleService()
        service.vehicleRepository = repository
        let request = VehicleProfileRequest(vehicleId: "60b0bed7ccb3c0786a603b80")
        let result = await service.getVehicleProfile(request: request)
        switch result {
        case .success(let vehicle):
                XCTAssertNotNil(vehicle.model.data?.first?.id)
        case .failure:
            XCTFail("Service Get vehicleprofile failed")
        }
    }
    
    func testValidateIMEI() async {
        let repository:VehicleRepositoryProtocol = VehicleRepositoryMock()
        var service =  VehicleService()
        service.vehicleRepository = repository
        let request = ValidateImeiRequest(imei: "167253671257915273")
        let result = await service.validateIMEI(request)
        switch result {
        case .success(let vehicle):
                XCTAssertNotNil(vehicle.model.first?.imei)
        case .failure:
            XCTFail("Service Validate IMEI failed")
        }
    }
    
    func testAddDevice() async {
        let repository:VehicleRepositoryProtocol = VehicleRepositoryMock()
        var service =  VehicleService()
        service.vehicleRepository = repository
        let request = AssociateRequest(imei: "167253671257915273")
        let result = await service.addDevice(request)
        switch result {
        case .success(let vehicle):
            XCTAssertNotNil(vehicle.model.associationId)
        case .failure:
            XCTFail("Service add device failed")
        }
    }
        
    func testRemoveDevice() async {
        let repository:VehicleRepositoryProtocol = VehicleRepositoryMock()
        var service =  VehicleService()
        service.vehicleRepository = repository
        let request = TerminateRequest(imei: "167253671257915273")
            let result = await service.removeDevice(request)
            switch result {
            case .success(let vehicle):
                XCTAssertNotNil(vehicle)
            case .failure:
                XCTFail("Service remove device failed")
            }
        }
    
    func testUpdateVehicleProfile() async {
        let repository:VehicleRepositoryProtocol = VehicleRepositoryMock()
        var service =  VehicleService()
        service.vehicleRepository = repository
        let attributes = Attributes(vehicleAttributes: VehicleAttribute(name: "my car"))
        let request = UpdateProfileRequest(vehicleId: "DOZWRTAJDT5163", params: attributes)
            let result = await service.updateVehicleProfile(request)
            switch result {
            case .success(let vehicle):
                XCTAssertNotNil(vehicle)
            case .failure:
                XCTFail("service update vehicle failed")
            }
        }
    
    
    
}


final class VehicleRepositoryMock:VehicleRepositoryProtocol {
    func getVehicleProfile(request: VehicleProfileRequest) async ->
    Result<Response<VehicleProfileCollection>, CustomError> {
        let dataMock = DataMock()
        let result = dataMock.readData(fromFile: "vehicleProfile")
        return await Helper.decoded(result, VehicleProfileCollection.self)
    }

    func getAssociatedVehicles() async -> Result<Response<Vehicles>, CustomError> {
        let dataMock = DataMock()
        let result = dataMock.readData(fromFile: "vehicleAssociationsList")
        return await Helper.decoded(result, Vehicles.self)
    }

    func updateVehicleProfile(_ request: UpdateProfileRequest) async ->
    Result<Response<UpdateVehicleResponse>, CustomError> {
        let dataMock = DataMock()
        let result = dataMock.readData(fromFile: "updateProfile")
        return await Helper.decoded(result, UpdateVehicleResponse.self)
    }

    func validateIMEI(_ request: ValidateImeiRequest) async ->
    Result<Response<[ImeiVerification]>, CustomError> {
        let dataMock = DataMock()
        let result = dataMock.readData(fromFile: "validateImei")
        return await Helper.decoded(result, [ImeiVerification].self)
    }

    func addDevice(_ request: AssociateRequest) async -> 
    Result<Response<DeviceAssociation>, CustomError> {
        let dataMock = DataMock()
        let result = dataMock.readData(fromFile: "associateDevice")
        return await Helper.decoded(result, DeviceAssociation.self)
    }

    func removeDevice(_ request: TerminateRequest) async -> 
    Result<Response<DeviceTermination>, CustomError> {
        let dataMock = DataMock()
        let result = dataMock.readData(fromFile: "terminareDevice")
        return await Helper.decoded(result, DeviceTermination.self)
    }
}

