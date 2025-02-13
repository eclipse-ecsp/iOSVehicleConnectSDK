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

///  Vehicle profile response
public struct VehicleProfileCollection: Codable {
    public var message: String?
    public var data: [VehicleProfile]?
}

/// Vehicle profile properties
public struct VehicleProfile: Codable {
    public var id: String?
    public var role: String?
    public var vin: String?
    public var createdOn: Double?
    public var updatedOn: Double?
    public var vehicleAttributes: VehicleAttribute?
    public var authorizedUsers: [AuthorizedUser]?
    public var modemInfo: ModemInfo?
    public var vehicleArchType: String?
    public var ecus: Ecus?
    public var deviceId: String?

    enum CodingKeys: String, CodingKey {
        case id = "vehicleId"
        case role
        case vin
        case createdOn
        case updatedOn
        case vehicleAttributes
        case authorizedUsers
        case modemInfo
        case vehicleArchType
        case ecus
        case deviceId
    }
   public mutating func updateModem(info: ModemInfo) {
        self.modemInfo = info
    }
    public mutating func updateDeviceId(id: String) {
         self.deviceId = id
     }
}
///  Autherised user associated to vehicle
public struct AuthorizedUser: Codable {

    public var id: String?
    public var role: String?

    enum CodingKeys: String, CodingKey {
        case id = "userId"
        case role
    }
}

/// Vehicle  properties
public struct VehicleAttribute: Codable {
    public var make: String?
    public var model: String?
    public var marketingColor: String?
    public var baseColor: String?
    public var modelYear: String?
    public var destinationCountry: String?
    public var engineType: String?
    public var bodyStyle: String?
    public var bodyType: String?
    public var name: String?
    public var type: String?
    public var fuelType: String?

    public init(name: String) {
        self.name = name
    }
}

///   Vehicles basic information that identify the device
public struct ModemInfo: Codable {
    public var id: String?
    public var iccid: String?
    public var imei: String?
    public var msisdn: String?
    public var imsi: String?
    public var deviceType: String?
    public var state: String?
    public var firmareVersion: String?

    enum CodingKeys: String, CodingKey {
        case id = "eid"
        case iccid
        case imei
        case msisdn
        case imsi
        case deviceType
        case state
        case firmareVersion
    }
    public init(id: String?,
                iccid: String?,
                imei: String?,
                msisdn: String?,
                imsi: String?,
                deviceType: String?,
                state: String?,
                firmwareVersion: String?) {
        self.id = id
        self.iccid = iccid
        self.imei = imei
        self.msisdn = msisdn
        self.imsi = imsi
        self.deviceType = deviceType
        self.state = state
        self.firmareVersion = firmwareVersion
    }
}

///    This identify the device  type
public struct Ecus: Codable {
    public var dongle: DeviceInfo?
    public var dashcam: DeviceInfo?
}

/// Device type information
public struct DeviceInfo: Codable {
    public var serialNo: String?
    public var clientId: String?
    public var capabilities: Capabilities?
    public var provisionedServices: Capabilities?
}
/// Capability means what services are activated  by the bvehicle
public struct Capabilities: Codable {
    public var services: [Service]?
}
///  Id of activated service by the vehicle
public struct Service: Codable {
    public var applicationId: String?
}
