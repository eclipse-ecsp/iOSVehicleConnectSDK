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

/// Protocol that declares the  remote operation repository functions
protocol RemoteOperationRepositoryProtocol {

    func getROHistory(_ request: RemoteOperationHistoryRequest) async ->
    Result<Response<[RemoteEventHistory]>, CustomError>

    func getROCommandRequest(_ request: RemoteEventStatusRequest) async ->
    Result<Response<RemoteEventHistory>, CustomError>

    func setROCommandRequest(_ request: RemoteEventUpdateRequest) async ->
    Result<Response<RemoteEventRequestStatus>, CustomError>
}

/// RemoteOperationRepository defnes the RemoteOperationRepositoryProtocol functions that 
/// sned the api request to process and return the appropriate response with model and raw data or error
struct RemoteOperationRepository: RemoteOperationRepositoryProtocol {
   var client: HTTPClientProtocol
   public init() {
       client = HTTPClient()
   }

    func getROHistory(_ request: RemoteOperationHistoryRequest) async ->
    Result<Response<[RemoteEventHistory]>, CustomError> {
        let result = await client.sendRequest(endpoint: RemoteOperationEndpoint.getROHistory(request))
        return await Helper.decoded(result, [RemoteEventHistory].self)
    }

    func getROCommandRequest(_ request: RemoteEventStatusRequest) async ->
    Result<Response<RemoteEventHistory>, CustomError> {
        let result = await client.sendRequest(endpoint: RemoteOperationEndpoint.getROCommandRequest(request))
        return await Helper.decoded(result, RemoteEventHistory.self)
    }

    func setROCommandRequest(_ request: RemoteEventUpdateRequest) async ->
    Result<Response<RemoteEventRequestStatus>, CustomError> {
        let result = await client.sendRequest(endpoint: RemoteOperationEndpoint.setROCommandRequest(request))
        return await Helper.decoded(result, RemoteEventRequestStatus.self)
    }
}
