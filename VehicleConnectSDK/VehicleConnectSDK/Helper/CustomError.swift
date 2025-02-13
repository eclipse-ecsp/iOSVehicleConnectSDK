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

/// Custom and network errors
public enum CustomError: Error {
    case networkError(NetworkError)
    case notRechable
    case decode
    case emptyToken
    case alreadySignin
    case refreshTokenFailed
    case invalidRequest
    case environmentNotConfigured
    case generic(String)

    public var message: String {
        switch self {
        case .networkError(let networkError):
            switch networkError {
            case .invalidURL:
                return ErrorMessage.kInvalidUrl
            case .noResponse:
                return ErrorMessage.kNoResponse
            case .unauthorized:
                return ErrorMessage.kUnauthorized
            case .unexpectedStatusCode:
                return ErrorMessage.kUnexpectedStatusCode
            case .unknown(let text):
                return text
            default:
                return ""
            }
        case .notRechable:
            return ErrorMessage.kNotReachableError
        case .decode:
            return ErrorMessage.kDecodeError
        case .emptyToken:
            return ErrorMessage.kEmptyToken
        case .alreadySignin:
            return ErrorMessage.kAlreadySignin
        case .refreshTokenFailed:
            return ErrorMessage.kRefreshTokenFailedError
        case .invalidRequest:
            return ErrorMessage.kInvalidRequest
        case .environmentNotConfigured:
            return ErrorMessage.kEnvironmentNotConfigured
        case .generic(let text):
            return text
        }
    }
}
