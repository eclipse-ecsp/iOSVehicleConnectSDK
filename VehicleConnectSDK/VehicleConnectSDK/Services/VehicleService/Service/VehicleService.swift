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

/// RemoteOperationServiceable protocol declare remote operation service public functions
///  thosse can be called from outside the sdk
public protocol VehicleServiceable {

    /// Fetch vehicle details
    /// - Parameter vehicleId: Associated vehicle id
    /// - Returns:
    /// Response:  Raw data with model
    /// CustomError: Error
    func getVehicleProfile(request: VehicleProfileRequest) async ->
    Result<Response<VehicleProfileCollection>, CustomError>

    /// List of associated vehicles with the useraccount
    /// - Returns:
    /// Response:  Data model ofl list of all the vehicles associated irrespictive of all status and raw data
    /// Custome Error: Error
    func getAssociatedVehicles() async -> Result<Response<Vehicles>, CustomError>

    /// Update the Vehicle Profile sttribute like  vehicle name , color, model, make etc.
    /// - Parameter request: UpdateProfileRequest with VehicleId and vehicle attributes inside post params
    /// - Returns:
    /// Response:  Data model with messahe, data and raw data
    /// CustomError: Error
    func updateVehicleProfile(_ request: UpdateProfileRequest) async ->
    Result<Response<UpdateVehicleResponse>, CustomError>

    /// Validate the IMEI
    /// - Parameter request: IMEI
    /// - Returns:
    /// Response:  IMEIVerification Model containg the  device information and raw data
    /// CustomError: Error
    func validateIMEI(_ request: ValidateImeiRequest) async -> Result<Response<[ImeiVerification]>, CustomError>

    /// Associate the device
    /// - Parameter request: params like IMEI serial numbers
    /// - Returns:
    /// Response:  DeviceAssociation Model containg the  device information and raw data
    /// CustomError: Error
    func addDevice(_ request: AssociateRequest) async -> Result<Response<DeviceAssociation>, CustomError>

    /// Terminate or remove  the device
    /// - Parameter request: params like IMEI
    /// - Returns:
    /// Response:  DeviceTermination Model containg  message and code and raw data
    /// CustomError: Error
    func removeDevice(_ reqParams: TerminateRequest) async -> Result<Response<DeviceTermination>, CustomError>
}

/// RemoteOperationService defnes the public RemoteOperationServiceable functions 
/// to fetch and update the remote operation services data
public struct VehicleService: VehicleServiceable {

    var vehicleRepository: VehicleRepositoryProtocol

    public init() {
        vehicleRepository = VehicleRepository()
    }

    public func getVehicleProfile(request: VehicleProfileRequest) async ->
    Result<Response<VehicleProfileCollection>, CustomError> {
        return await vehicleRepository.getVehicleProfile(request: request)
    }

    public func getAssociatedVehicles() async ->
    Result<Response<Vehicles>, CustomError> {
        return await vehicleRepository.getAssociatedVehicles()
    }

    public func updateVehicleProfile(_ request: UpdateProfileRequest) async ->
    Result<Response<UpdateVehicleResponse>, CustomError> {
        return await vehicleRepository.updateVehicleProfile(request)
    }

   public func validateIMEI(_ request: ValidateImeiRequest) async ->
    Result<Response<[ImeiVerification]>, CustomError> {
       return await vehicleRepository.validateIMEI(request)
    }

    public func addDevice(_ request: AssociateRequest) async -> Result<Response<DeviceAssociation>, CustomError> {
        return await vehicleRepository.addDevice(request)
    }

    public func removeDevice(_ request: TerminateRequest) async -> Result<Response<DeviceTermination>, CustomError> {
        return await vehicleRepository.removeDevice(request)
    }
}
