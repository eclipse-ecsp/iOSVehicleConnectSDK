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

/// Protocol that declares the notification repository functions
protocol NotificationRepositoryProtocol {
    func getAlerts(_ request: NotificationRequest) async -> Result<Response<VehicleAlerts>, CustomError>
    func shareDeviceToken(_ request: DeviceTokenRequest) async -> Result<Response<Bool>, CustomError>
}

/// NotificationRepository defnes the NotificationRepositoryProtocol functions  that sned the api request
///  to process and return the appropriate response with model and raw data or error
struct NotificationRepository: NotificationRepositoryProtocol {
    var client: HTTPClientProtocol
    public init() {
        client = HTTPClient()
    }

    func getAlerts(_ request: NotificationRequest) async -> Result<Response<VehicleAlerts>, CustomError> {
        let result = await client.sendRequest(endpoint: NotificationEndpoint.getAlerts(request))
        return await Helper.decoded(result, VehicleAlerts.self)
    }

    func shareDeviceToken(_ request: DeviceTokenRequest) async -> Result<Response<Bool>, CustomError> {
        let result = await client.sendRequest(endpoint: NotificationEndpoint.shareDeviceToken(request))
        return await Helper.decoded(result, Bool.self)
    }
}
