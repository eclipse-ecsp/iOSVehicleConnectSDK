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

///  Update vehicle profile request
public struct UpdateProfileRequest: Codable {

    public let vehicleId: String
    public let params: Attributes

    public init(vehicleId: String, params: Attributes) {
        self.vehicleId = vehicleId
        self.params = params
    }
}

/// Post parameters of update profile request
public struct Attributes: Codable {

    public let vehicleAttributes: VehicleAttribute

    public init(vehicleAttributes: VehicleAttribute) {
        self.vehicleAttributes = vehicleAttributes
    }
}
