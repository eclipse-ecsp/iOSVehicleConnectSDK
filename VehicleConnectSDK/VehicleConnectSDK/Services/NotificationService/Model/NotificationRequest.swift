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

///  Request Model for getting the notification alerts history data
public struct NotificationRequest: Codable {

    public let vehicleId: String
    public let query: QueryData

    public init(vehicleId: String, query: QueryData) {
        self.vehicleId = vehicleId
        self.query = query
    }
}

/// Model for post parameters data to passed in the  alerts history api
public struct QueryData: Codable {

    public let from: String
    public let till: String
    public let alertType: String
    public let readStatus: String
    public let page: Int
    public let size: Int

    public init(from: String, till: String, alertType: String, readStatus: String, page: Int, size: Int) {
        self.from = from
        self.till = till
        self.alertType = alertType
        self.readStatus = readStatus
        self.page = page
        self.size = size
    }
}
