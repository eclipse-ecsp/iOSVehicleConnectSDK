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

/// Authentication manager  shared class that inject  the authentication dependencies using AuthProtocol
public class AuthManager {
    public static let shared = AuthManager()
    @Injected(\.authProtocol) public var authProtocol: AuthProtocol
}

struct AppAuthManagerKey: InjectionKey {
    static var currentValue: AuthProtocol = AppAuthProvider.initialize()
}

extension InjectedValues {
    var authProtocol: AuthProtocol {
        get { Self[AppAuthManagerKey.self] }
        set { Self[AppAuthManagerKey.self] = newValue }
    }
}
