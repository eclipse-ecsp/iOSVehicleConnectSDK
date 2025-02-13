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

/// NotificationServiceable protocol declare Notification service public functions thosse can be called
///  from outside the sdk
public protocol NotificationServiceable {

    /// To  fetch the list of alerts notifications
    /// - Parameter request: NotificationRequest vehicleId, params(since, untill, alertType, readStatus, page and size)
    /// - Returns: List of vehicle Alerts with raw data
    func getAlerts(_ request: NotificationRequest) async -> Result<Response<VehicleAlerts>, CustomError>

    /// To share the Device token/ FCM token to the server
    /// - Parameter request: DeviceTokenRequest with  vehicleId, userId and  params(group, channels and enabled)
    /// - Returns: No data is returned with this request only success and fail response
    func shareDeviceToken(_ request: DeviceTokenRequest) async -> Result<Response<Bool>, CustomError>
}

/// NotificationService defnes the public RemoteOperationServiceable functions to fetch
///  and update the notofication services data
public struct NotificationService: NotificationServiceable {

    var notificationRepository: NotificationRepositoryProtocol

    public init() {
        notificationRepository = NotificationRepository()
    }

    public func getAlerts(_ request: NotificationRequest)
    async -> Result<Response<VehicleAlerts>, CustomError> {
        return await notificationRepository.getAlerts(request)
    }

    public func shareDeviceToken(_ request: DeviceTokenRequest) async ->
    Result<Response<Bool>, CustomError> {
        return await notificationRepository.shareDeviceToken(request)
    }
}
