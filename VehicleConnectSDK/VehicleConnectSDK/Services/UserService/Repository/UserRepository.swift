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

/// Protocol that declares the user repository functions
protocol UserRepositoryProtocol {
    func signInWithAppAuth() async -> Result<Bool, CustomError>
    func signUpWithAppAuth() async -> Result<Bool, CustomError>
    func signOutWithAppAuth() async -> Result<Bool, CustomError>
    func refreshAccessToken() async -> Result<Bool, CustomError>
    func isAuthorizationExpired() -> Bool
    func getUserProfile() async -> Result<Response<UserProfile>, CustomError>
}

/// UserRepository defnes the UserRepositoryProtocol functions that sned the api request to process and 
/// return the appropriate response with model and raw data or error
struct UserRepository: UserRepositoryProtocol {
    var client: HTTPClientProtocol
    public init() {
        client = HTTPClient()
    }

    func signInWithAppAuth() async -> Result<Bool, CustomError> {
        return await AuthManager.shared.authProtocol.signIn()
    }

    func signUpWithAppAuth() async -> Result<Bool, CustomError> {
        return await AuthManager.shared.authProtocol.signUp()
    }

    func signOutWithAppAuth() async -> Result<Bool, CustomError> {
        return await AuthManager.shared.authProtocol.signOut()
    }

    func refreshAccessToken() async -> Result<Bool, CustomError> {
        return await AuthManager.shared.authProtocol.refreshAccessToken()
    }

    func isAuthorizationExpired() -> Bool {
        return AuthManager.shared.authProtocol.isAuthorizationExpired()
    }
}

extension UserRepository {

    func getUserProfile() async -> Result<Response<UserProfile>, CustomError> {
        let result = await client.sendRequest(endpoint: UserEndpoint.profile)
        return await Helper.decoded(result, UserProfile.self)
    }
}
