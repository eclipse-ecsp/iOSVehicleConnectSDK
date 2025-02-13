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

import Foundation

/// Environment endpoints properties
public struct EnvironmentDetail: Codable {
    public let title: String
    public let clientId: String
    public let clientSecret: String
    public let baseUrl: String
    public var profileURL: String
    public let signInUrl: String
    public let signUpUrl: String
    public let redirectUrl: String
    public let compatibilityUrl: String
    public let scopes: [String]

    enum CodingKeys: String, CodingKey {
        case title
        case scopes
        case clientId = "client_Id"
        case clientSecret = "client_secret"
        case baseUrl = "base_url"
        case profileURL = "profile_url"
        case signInUrl = "signin_url"
        case signUpUrl = "signup_url"
        case redirectUrl = "redirect_url"
        case compatibilityUrl = "compatibility_url"
    }
}
