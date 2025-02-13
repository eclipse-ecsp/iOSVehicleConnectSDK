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

///  Request Model for sharing the device token to server
public struct DeviceTokenRequest: Codable {

    public let vehicleId: String
    public let userId: String
    public let postData: [ChannelData]

    public init(vehicleId: String, userId: String, postData: [ChannelData]) {
        self.vehicleId = vehicleId
        self.userId = userId
        self.postData = postData
    }
}

/// Model for post parameters of  share device token request
public struct ChannelData: Codable {

    public let group: String
    public let channels: [Channel]
    public let enabled: Bool

    public init(group: String, channels: [Channel], enabled: Bool) {
        self.group = group
        self.channels = channels
        self.enabled = enabled
    }
}

///  Inner lavel post parameters
public struct Channel: Codable {

    public let appPlatform: String
    public let type: String
    public let enabled: Bool
    public let deviceTokens: [String]
    public let service: String

    public init(appPlatform: String, type: String, enabled: Bool, deviceTokens: [String], service: String) {
        self.appPlatform = appPlatform
        self.type = type
        self.enabled = enabled
        self.deviceTokens = deviceTokens
        self.service = service
    }
}
