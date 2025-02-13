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
/// thosse can be called from outside the sdk
public protocol RemoteOperationServiceable {
    ///  Get the RO History data
    /// - Parameter request: ROHistoryRequest containg userId and vehicleId
    /// - Returns:
    /// Response:  ROEventHistory Models list and raw data
    /// CustomError: Error
    func getROHistory(_ request: RemoteOperationHistoryRequest) async ->
    Result<Response<[RemoteEventHistory]>, CustomError>

    ///  Get the current RO set  request status
    /// - Parameter request: ROGetStatusRequest containing current requestId, useId and vehicleId
    /// - Returns:
    /// Response:  ROEventHistory Model and raw data
    /// CustomError: Error
    func getRORequest(_ request: RemoteEventStatusRequest) async ->
    Result<Response<RemoteEventHistory>, CustomError>

    ///  Update the RO settings
    /// - Parameter request: ROStatusRequest containing   useId and vehicleId, stateType and post params
    /// - Returns:
    /// Response:  RORequestStatus Model and raw data
    /// CustomError: Error
    func setRORequest(_ request: RemoteEventUpdateRequest) async ->
    Result<Response<RemoteEventRequestStatus>, CustomError>
}

/// RemoteOperationService defnes the public RemoteOperationServiceable functions to fetch 
/// and update the remote operation services data
public struct RemoteOperationService: RemoteOperationServiceable {
     var roRepository: RemoteOperationRepositoryProtocol

    public init() {
        roRepository = RemoteOperationRepository()
    }

    public func `getROHistory`(_ request: RemoteOperationHistoryRequest) async ->
    Result<Response<[RemoteEventHistory]>, CustomError> {
        return await roRepository.getROHistory(request)
    }

    public func getRORequest(_ request: RemoteEventStatusRequest) async ->
    Result<Response<RemoteEventHistory>, CustomError> {
        return await roRepository.getROCommandRequest(request)
    }

    public func setRORequest(_ request: RemoteEventUpdateRequest) async ->
    Result<Response<RemoteEventRequestStatus>, CustomError> {
        return await roRepository.setROCommandRequest(request)
    }
}
