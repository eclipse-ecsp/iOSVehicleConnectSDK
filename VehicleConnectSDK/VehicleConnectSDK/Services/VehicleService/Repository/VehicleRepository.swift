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

/// Protocol that declares the vehicle repository functions
protocol VehicleRepositoryProtocol {
    func getVehicleProfile(request: VehicleProfileRequest) async ->
                          Result<Response<VehicleProfileCollection>, CustomError>

    func getAssociatedVehicles() async -> Result<Response<Vehicles>, CustomError>

    func updateVehicleProfile(_ request: UpdateProfileRequest) async ->
                          Result<Response<UpdateVehicleResponse>, CustomError>

    func validateIMEI(_ request: ValidateImeiRequest) async -> Result<Response<[ImeiVerification]>, CustomError>

    func addDevice(_ request: AssociateRequest) async -> Result<Response<DeviceAssociation>, CustomError>

    func removeDevice(_ request: TerminateRequest) async -> Result<Response<DeviceTermination>, CustomError>
}

/// VehicleRepository defnes the VehicleRepositoryProtocol functions that sned the api request to process and 
/// return the appropriate response with model and raw data or error
struct VehicleRepository: VehicleRepositoryProtocol {
    var client: HTTPClientProtocol
    public init() {
        client = HTTPClient()
    }

    func getVehicleProfile(request: VehicleProfileRequest) async ->
    Result<Response<VehicleProfileCollection>, CustomError> {
        let result = await client.sendRequest(endpoint: VehicleEndpoint.vehicleProfile(request))
        return await Helper.decoded(result, VehicleProfileCollection.self)
    }

    func getAssociatedVehicles() async -> Result<Response<Vehicles>, CustomError> {
        let result = await client.sendRequest(endpoint: VehicleEndpoint.associatedVehicle)
        return await Helper.decoded(result, Vehicles.self)
    }

    func updateVehicleProfile(_ request: UpdateProfileRequest) async ->
    Result<Response<UpdateVehicleResponse>, CustomError> {
        let result = await client.sendRequest(endpoint: VehicleEndpoint.updateVehicleProfile(request))
        return await Helper.decoded(result, UpdateVehicleResponse.self)
    }

    func validateIMEI(_ request: ValidateImeiRequest) async -> Result<Response<[ImeiVerification]>, CustomError> {
        let result = await client.sendRequest(endpoint: VehicleEndpoint.validateIMEI(request))
        return await Helper.decoded(result, [ImeiVerification].self)
    }

    func addDevice(_ request: AssociateRequest) async -> Result<Response<DeviceAssociation>, CustomError> {
        let result = await client.sendRequest(endpoint: VehicleEndpoint.addDevice(request))
        return await Helper.decoded(result, DeviceAssociation.self)
    }

    func removeDevice(_ request: TerminateRequest) async -> Result<Response<DeviceTermination>, CustomError> {
        let result = await client.sendRequest(endpoint: VehicleEndpoint.removeDevice(request))
        return await Helper.decoded(result, DeviceTermination.self)
    }
}
