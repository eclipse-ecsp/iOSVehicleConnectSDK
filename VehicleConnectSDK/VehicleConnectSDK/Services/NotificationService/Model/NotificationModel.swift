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

/// Vehicle notification  api response model
public struct VehicleAlerts: Codable {

    public var alerts: [Alert] = []
    public var pagination: PaginationInfo?
    public var read: [String]? = []
    public var unread: [String]? = []
}
/// Vehicle events notification alerts
public struct Alert: Codable {

    public var alertType: String?
    public var pdid: String?
    public var timestamp: TimeInterval?
    public var alertMessage: String?
    public var status: String?
    public var alertId: String?
    public var globalDoorLockStatus: Int?

    enum CodingKeys: String, CodingKey {
        case alertType
        case alertMessage
        case timestamp
        case alertId = "id"
        case globalDoorLockStatus
    }
}
/// Pagination details of notification alerts api
public struct PaginationInfo: Codable {

    public var page: Int
    public var size: Int
    public var total: RecoardInfo?
}

/// records  details of notification alerts api
public struct RecoardInfo: Codable {

    public var records: Int
    public var pages: Int
}
