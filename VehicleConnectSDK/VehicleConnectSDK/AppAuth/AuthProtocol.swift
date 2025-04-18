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
import UIKit

///  A protocol that declare authentication  properties and function
public protocol AuthProtocol {
    var accessToken: String { get set }
    var refreshToken: String { get set }
    var tokenType: String { get set }
    var scope: String { get set }
    var accessTokenExpirationDate: Date { get set }
    var additionalParameters: [AnyHashable: Any] { get set }

    func signIn(_ vc: UIViewController) async -> Result<Bool, CustomError>
    func signUp(_ vc: UIViewController) async -> Result<Bool, CustomError>
    func signOut() async -> Result<Bool, CustomError>
    func refreshAccessToken() async -> Result<Bool, CustomError>
    func isAuthorizedUser() -> Bool
    func isAuthorizationExpired() -> Bool
}
