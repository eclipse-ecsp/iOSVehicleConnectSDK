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

// Unit test endpoint constant
struct TestingEndpoint {
  static let kBaseUrl = "https://abchfashga.com/"
  static let kProfileUrl = "https://abchfashga.com/"
}

// Authentication token and refresh token constant
struct RefreshTokenMessage {
    static let kStarted       = "Refresh token request started."
    static let kInProgress    = "We are still waiting to get refresh token."
    static let kCompleted     = "Refresh token request completed."
    static let kFailed        = "Refresh token request failed."
    static let vBearer        = "Bearer "
    static let kAuthorization = "Authorization"
}

///  Network Error Constant
struct ErrorMessage {
    static let kNotReachableError        = "No network connection"
    static let kDecodeError              = "Decode error"
    static let kInvalidUrl               = "Invalid url"
    static let kUnauthorized             = "Unauthorized error"
    static let kNoResponse               = "No response"
    static let kUnexpectedStatusCode     = "unexpected status code"
    static let kUnknown                  = "unknown error"
    static let kEnvironmentNotConfigured = "Environment not configured"
    static let kEmptyToken               = "Refresh token is empty or user is not sign in."
    static let kAlreadySignin            = "User already signin. Please continue making request."
    static let kRefreshTokenFailedError  = "We have reached maximum retry for refresh token. Therefore clear the token."
    static let kInvalidRequest           = "Invalid request"
}
/// header request constant
struct Header {
    static let vBearer        = "Bearer "
    static let kAuthorization = "Authorization"
    static let kContentType = "Content-type"
    static let vContentTypeJSON = "application/json"
    static let kOriginId = "OriginId"
    static let vOrigin = "iOS"
    static let kSessionId = "SessionId"
    static let kRequestId = "RequestId"

}
