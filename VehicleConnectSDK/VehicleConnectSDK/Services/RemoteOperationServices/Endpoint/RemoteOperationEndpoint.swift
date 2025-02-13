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

/// Enum RemoteOperationEndpoint  defines url, header, request method and request body for remote operation  services
enum RemoteOperationEndpoint {
    case getROHistory(RemoteOperationHistoryRequest)
    case getROCommandRequest(RemoteEventStatusRequest)
    case setROCommandRequest(RemoteEventUpdateRequest)
}

extension RemoteOperationEndpoint: Endpoint {

    var baseUrl: String {
        if let baseUrl = AppManager.environment?.baseUrl {
            return baseUrl
        }
        return TestingEndpoint.kBaseUrl
    }

    var path: String {
        switch self {
        case .getROHistory(let request):
            return "v1.1/users/\(request.userId)/vehicles/\(request.vehicleId)/ro/history"
        case .getROCommandRequest(let reuest):
            return "v1.1/users/\(reuest.userId)/vehicles/\(reuest.vehicleId)/ro/requests/\(reuest.reuestId)"
        case .setROCommandRequest(let request):
            return "v1.1/users/\(request.userId)/vehicles/\(request.vehicleId)/ro/\(request.stateType!)"
        }
    }

    var header: [String: String]? {
        let token = AuthManager.shared.authProtocol.accessToken
        let type =  Header.vContentTypeJSON
        let origin = Header.vOrigin
        let sessionId = Helper.randomString(length: 22)
        let requestId = Helper.randomString(length: 22)
        return [Header.kAuthorization: Header.vBearer + token, Header.kContentType: type,
                Header.kOriginId: origin, Header.kSessionId: sessionId, Header.kRequestId: requestId]
    }

    var method: RequestMethod {
        switch self {
        case .getROHistory, .getROCommandRequest:
            return .get
        case .setROCommandRequest:
            return .put
        }
    }

    var body: Any? {
        switch self {
        case .getROHistory, .getROCommandRequest:
            return nil
        case .setROCommandRequest(let request):
            return request.postData?.param
        }
    }
}
