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

/// Enum VehicleEndpoint  defines url, header, request method and request body for vehicle services
enum VehicleEndpoint {
    case vehicleProfile(VehicleProfileRequest)
    case associatedVehicle
    case updateVehicleProfile(UpdateProfileRequest)
    case validateIMEI(ValidateImeiRequest)
    case addDevice(AssociateRequest)
    case removeDevice(TerminateRequest)
}

extension VehicleEndpoint: Endpoint {

    var baseUrl: String {
        if let baseUrl = AppManager.environment?.baseUrl {
            return baseUrl
        }
        return TestingEndpoint.kBaseUrl
    }

    var path: String {
        switch self {
        case .vehicleProfile(let request):
            return "v1.0/vehicles?clientId=\(request.vehicleId)"
        case .associatedVehicle:
            return "v3/user/associations/"
        case .updateVehicleProfile(let request):
            return "v1.0/vehicles/\(request.vehicleId)"
        case .validateIMEI(let request):
            return "v1/devices/details?imei=\(request.imei)"
        case .addDevice:
            return "v3/user/devices/associate/"
        case .removeDevice:
            return "v2/user/associations/terminate"
        }

    }

    var header: [String: String]? {
        let tokenType = AuthManager.shared.authProtocol.tokenType
        let token = AuthManager.shared.authProtocol.accessToken
        return ["Authorization": "\(tokenType) \(token)", "Content-Type": "application/json"]
    }

    var method: RequestMethod {
        switch self {
        case .updateVehicleProfile:
            return .patch
        case .addDevice, .removeDevice:
            return .post
        default:
            return .get
        }
    }

    var body: Any? {
        switch self {
        case .updateVehicleProfile(let request):
            return request.params.json
        case .addDevice(let request):
            return request.json
        case .removeDevice(let request):
            return request.json
        default:
            return nil
        }
    }
}
