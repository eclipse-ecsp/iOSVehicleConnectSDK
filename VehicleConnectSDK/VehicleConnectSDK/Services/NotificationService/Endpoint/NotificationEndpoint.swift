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

/// Enum NotificationEendpoint  define url, header, request method and request body for notification services
enum NotificationEndpoint {
    case getAlerts(NotificationRequest)
    case shareDeviceToken(DeviceTokenRequest)
}

extension NotificationEndpoint: Endpoint {

    var baseUrl: String {
        if let baseUrl = AppManager.environment?.baseUrl {
            return baseUrl
        }
        return TestingEndpoint.kBaseUrl
    }

    var path: String {
        switch self {
        case .getAlerts(let request):
            let queryString = "?since=\(request.query.from)&until=\(request.query.till)" +
            "&size=\(request.query.size)&page=\(request.query.page)&readstatus=\(request.query.readStatus)"
            return "v3/devices/\(request.vehicleId)/alerts/\(request.query.alertType)\(queryString)"
        case .shareDeviceToken(let request):
            return "v1/vehicles/\(request.vehicleId)/contacts/self/notifications/config"
        }
    }

    var header: [String: String]? {
        let tokenType = AuthManager.shared.authProtocol.tokenType
        let token = AuthManager.shared.authProtocol.accessToken
        return ["Authorization": "\(tokenType) \(token)", "Content-Type": "application/json"]
    }

    var method: RequestMethod {
        switch self {
        case .getAlerts:
            return .get
        case .shareDeviceToken:
            return .patch
        }
    }

    var body: Any? {
        switch self {
        case .getAlerts:
            return nil
        case .shareDeviceToken(let request):
            return request.postData.json
        }
    }
}
