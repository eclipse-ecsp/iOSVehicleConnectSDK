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

/// Device association status
public enum DeviceAssociationStatus: String, Codable {
    case initiated = "ASSOCIATION_INITIATED"
    case associated  = "ASSOCIATED"
    case disAssociated  = "DISASSOCIATED"
    case disAssociatedFailed  = "DISASSOCIATED_FAILED"
    case suspended  = "SUSPEDNDED"
    case invalid  = "INVALID"
}

/// Device association status summary
public struct DeviceAssociation: Codable {

    public internal (set) var message: String?
    public internal (set) var code: String?
    public internal (set) var associationId: Int64?
    public internal (set) var status: DeviceAssociationStatus?

    enum CodingKeys: String, CodingKey {
        case associationId = "associationID"
        case status = "associationStatus"
        case message = "message"
        case code = "code"
    }
}

/// IMEI verification summary API response
public struct ImeiVerification: Codable {
    public internal (set) var manufacturingDate: Double = 0
    public internal (set) var recordDate: Double = 0
    public internal (set) var createdDate: Double = 0
    public internal (set) var model: String?
    public internal (set) var imei: String?
    public internal (set) var serialNumber: String?
    public internal (set) var packageSerialNumber: String?
    public internal (set) var platformVersion: String?
    public internal (set) var iccid: String?
    public internal (set) var ssid: String?
    public internal (set) var bssid: String?
    public internal (set) var msisdn: String?
    public internal (set) var imsi: String?
    public internal (set) var factoryAdmin: String?
    public internal (set) var state: String?
}
