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

/// Enum UserEndpoint  defines Url, header, request method and request body for user services
enum UserEndpoint {
    case signIn
    case signUp
    case signOut
    case changePassword
    case authToken
    case profile
    case refreshAccessToken
    case isAuthorizedUser
}

extension UserEndpoint: Endpoint {

    var baseUrl: String {
        if let baseUrl = AppManager.environment?.profileURL {
            return baseUrl
        }
        return TestingEndpoint.kProfileUrl
    }

    var path: String {
        switch self {
        case .signIn:
            return "oauth2/authorize"
        case .signUp:
            return "sign-up"
        case .signOut:
            return "?token=\(AuthManager.shared.authProtocol.accessToken)"
        case .changePassword:
            return "v1/users/self/recovery/resetpassword"
        case .authToken:
            return "oauth2/token"
        case .profile:
            return "v1/users/self"
        default:
            return ""
        }

    }

    var header: [String: String]? {
        let tokenType = AuthManager.shared.authProtocol.tokenType
        let token = AuthManager.shared.authProtocol.accessToken
        return ["Authorization": "\(tokenType) \(token)", "Content-Type": "application/json"]
    }

    var method: RequestMethod {
        switch self {
        case .changePassword:
            return .post
        default:
            return .get
        }
    }

    var body: Any? {
        return nil
    }
}
