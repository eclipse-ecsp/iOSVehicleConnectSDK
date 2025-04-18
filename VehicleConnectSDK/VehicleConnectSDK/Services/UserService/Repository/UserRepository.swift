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

import UIKit

/// Protocol that declares the user repository functions
protocol UserRepositoryProtocol {
    func signInWithAppAuth(_ vc: UIViewController) async -> Result<Bool, CustomError>
    func signUpWithAppAuth(_ vc: UIViewController) async -> Result<Bool, CustomError>
    func signOutWithAppAuth() async -> Result<Bool, CustomError>
    func refreshAccessToken() async -> Result<Bool, CustomError>
    func isAuthorizationExpired() -> Bool
    func getUserProfile() async -> Result<Response<UserProfile>, CustomError>
    func changePassword() async -> Result<Response<ChangePassword>, CustomError>
}

/// UserRepository defnes the UserRepositoryProtocol functions that sned the api request to process and 
/// return the appropriate response with model and raw data or error
struct UserRepository: UserRepositoryProtocol {
    var client: HTTPClientProtocol
    public init() {
        client = HTTPClient()
    }

    func signInWithAppAuth(_ vc: UIViewController) async -> Result<Bool, CustomError> {
        return await AuthManager.shared.authProtocol.signIn(vc)
    }

    func signUpWithAppAuth(_ vc: UIViewController) async -> Result<Bool, CustomError> {
        return await AuthManager.shared.authProtocol.signUp(vc)
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

    func changePassword() async -> Result<Response<ChangePassword>, CustomError> {
        let result = await client.sendRequest(endpoint: UserEndpoint.changePassword)
        return await Helper.decoded(result, ChangePassword.self)
    }
}
