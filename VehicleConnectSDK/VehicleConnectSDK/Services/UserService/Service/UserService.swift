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

/// UserServiceable protocol declare user service public functions thosse can be called from outside the sdk
public protocol UserServiceable {

    /// Sign in with authentication
    /// - Returns: Sign in status and error
    func signInWithAppAuth() async -> Result<Bool, CustomError>

    /// Sign up with authentication
    /// - Returns: Sign up status and error
    func signUpWithAppAuth() async -> Result<Bool, CustomError>

    /// Sign out with authentication
    /// - Returns: Sign out status and error
    func signOutWithAppAuth() async -> Result<Bool, CustomError>

    /// Fetch user profile detail
    /// - Returns:
    /// Response:  Raw data with model
    /// CustomError: Error
    func getUserProfile() async -> Result<Response<UserProfile>, CustomError>

    /// Get refresh Toket
    /// - Returns: Bool , error( refresh token succes or not)
    func refreshAccessToken() async -> Result<Bool, CustomError>

    ///   Check the autherization is expired
    /// - Returns: Bool 
    func isAuthorizationExpired() -> Bool
}

/// UserService defnes the public UserServiceable functions to fetch and update the user services data
public struct UserService: UserServiceable {

    var userRepository: UserRepositoryProtocol

    public init() {
        userRepository = UserRepository()
    }

    public func signInWithAppAuth() async -> Result<Bool, CustomError> {
        return await userRepository.signInWithAppAuth()
    }

    public func signUpWithAppAuth() async -> Result<Bool, CustomError> {
        return await userRepository.signUpWithAppAuth()
    }

    public func signOutWithAppAuth() async -> Result<Bool, CustomError> {
        return await userRepository.signOutWithAppAuth()
    }

   public func refreshAccessToken() async -> Result<Bool, CustomError> {
        return await userRepository.refreshAccessToken()
    }

    public func isAuthorizationExpired() -> Bool {
       return  userRepository.isAuthorizationExpired()
    }

    public func getUserProfile() async -> Result<Response<UserProfile>, CustomError> {
        return await userRepository.getUserProfile()
    }

}
