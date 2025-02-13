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

///  List of vehicles
 public struct Vehicles: Codable {

 public let vehiclesList: [Vehicle]?
 public let message: String?
 public let code: String?

    enum CodingKeys: String, CodingKey {
        case vehiclesList = "data"
        case message
        case code
    }
}

///  Vehicles properties
public struct Vehicle: Codable {
    public let imsi: String?
    public let state: String?
    public let serialNumber: String?
    public let iccid: String?
    public let msisdn: String?
    public let stolen: Bool?
    public let imei: String?
    public let bssid: String?
    public let ssid: String?
    public let deviceType: String?
    public let model: String?
    public let associationStatus: String?
    public let associatedOn: String?
    public let deviceId: String?
    public let softwareVersion: String?
}
