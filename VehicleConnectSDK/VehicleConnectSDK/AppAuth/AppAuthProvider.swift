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
import AppAuth

private let kRefreshTokenMaxRetryCount = 3
private let kBADURL = 400

struct AppAuthKey {
    static let kAuthorizationGrant    = "grant"
    static let kAuthorizationPrompt   = "prompt"
    static let kAuthorizationLogin    = "login"
    static let kLocale                = "locale"
    static let kAuthStateInfo         = "authStateInfo"
}

enum RefreshTokenRequestStatus: Int {
    case started
    case inprogress
    case completed
    case failed
    var statusInfo: String {
        switch self {
        case .started: return RefreshTokenMessage.kStarted
        case .inprogress: return RefreshTokenMessage.kInProgress
        case .completed: return RefreshTokenMessage.kCompleted
        case .failed: return RefreshTokenMessage.kFailed
        }
    }
}

/// Class for connecting the AppAuth library and  preserving the auth state
class AppAuthProvider: NSObject, AuthProtocol {

    var accessToken: String = ""
    var refreshToken: String = ""
    var accessTokenExpirationDate: Date = Date()
    var tokenType: String = ""
    var scope: String = ""
    var additionalParameters: [AnyHashable: Any] = [:]

    var retryCount: Int = 0
    var currentAuthorizationFlow: OIDExternalUserAgentSession?
    private var oidAuthState: OIDAuthState?

    private var refreshTokenRequestStatus: RefreshTokenRequestStatus = .completed
    private var pendingTokenRefreshTransactions: [(_ isSuccess: Bool) -> Void] = []

    ///   Refresh token api call
    private let tokenRefreshQueue = DispatchQueue(label: "com.test.tokenRefreshQueue", attributes: .concurrent)
    private let tokenRefreshSync = DispatchQueue(label: "com.test.tokenRefreshSyncQueue")

    /// Intialize the AppAuthProvider
    static func initialize() -> AppAuthProvider {
        return AppAuthProvider()
    }
    /// Class intializer
    override init() {
        super.init()

        if !SecureStoreManager.isFreshInstall {
            self.updateOTDAuthState(nil)
            SecureStoreManager.isFreshInstall = true
        }
        self.loadState()
    }
}

///  Definition of AuthProtocol function
extension AppAuthProvider: @unchecked Sendable {
    func signIn(_ vc: UIViewController) async -> Result<Bool, CustomError> {
        return await authentication(vc, forSignIn: true)
    }

    func signUp(_ vc: UIViewController) async -> Result<Bool, CustomError> {
        return await authentication(vc, forSignIn: false)
    }

    func signOut() async -> Result<Bool, CustomError> {
        self.updateOTDAuthState(nil)
        return .success(true)
    }

    func isAuthorizedUser() -> Bool {
        guard let item = self.oidAuthState else {
            return false
        }
        return item.isAuthorized
    }

    func refreshAccessToken() async -> Result<Bool, CustomError> {
        return await withCheckedContinuation { continuation in
            makeRequestToRefreshAccessToken { isSuccess in
                continuation.resume(returning: isSuccess ? .success(true) : .failure(.refreshTokenFailed))
            }
        }
    }
    ///   Making the authentication call on signin click
    private func authentication(_ vc: UIViewController, forSignIn: Bool) async -> Result<Bool, CustomError> {

        if !(self.accessToken.isEmpty) { return .failure(.alreadySignin)}

        guard let environment = AppManager.environment else { return .failure(.environmentNotConfigured) }
        let baseUrl = forSignIn ? environment.signInUrl : environment.signUpUrl
        let authEndpoint = baseUrl + (forSignIn ? UserEndpoint.signIn.path : UserEndpoint.signUp.path)
        let tokenEndpoint = baseUrl + UserEndpoint.authToken.path
        return await withCheckedContinuation { continuation in
            self.authenticate(vc, environment: environment, authEndpoint: authEndpoint,
                              tokenEndpoint: tokenEndpoint) { isSuccess in
                continuation.resume(returning: isSuccess ? .success(true) : .failure(.emptyToken))
            }
        }
    }

    ///  Authenticate function to create auth request
    private func authenticate(_ vc: UIViewController,
                              environment: EnvironmentDetail,
                              authEndpoint: String, tokenEndpoint: String,
                              _ handler: @Sendable @escaping (_ isSuccess: Bool) -> Void) {
        guard let authUrl = URL.init(string: authEndpoint),
              let tokenUrl = URL.init(string: tokenEndpoint),
              let redirectUrl = URL.init(string: environment.redirectUrl) else { return }

        let additionalParams = [AppAuthKey.kAuthorizationGrant: OIDGrantTypeAuthorizationCode,
                                AppAuthKey.kAuthorizationPrompt: AppAuthKey.kAuthorizationLogin,
                                AppAuthKey.kLocale: String(Helper.deviceLocale.split(separator: "-").first!) ]

        let configuration = OIDServiceConfiguration(authorizationEndpoint: authUrl, tokenEndpoint: tokenUrl)

        let request = OIDAuthorizationRequest(configuration: configuration, clientId: environment.clientId,
                                              clientSecret: environment.clientSecret, scopes: environment.scopes,
                                              redirectURL: redirectUrl, responseType: OIDResponseTypeCode,
                                              additionalParameters: additionalParams)

        DebugPrint.info("App auth request: \(request)")
        DispatchQueue.main.async {
            self.currentAuthorizationFlow =
            OIDAuthState.authState(byPresenting: request,
                                   presenting: vc,
                                   prefersEphemeralSession: true) { [weak self, handler] authState, error in
                if let authState = authState {
                    self?.updateOTDAuthState(authState)
                    handler(true)
                } else {
                    DebugPrint.info("Authorization error: \(error?.localizedDescription ?? "Unknown error")")
                    self?.updateOTDAuthState(nil)
                    handler(false)
                }
            }
        }
    }

    private func makeRequestToRefreshAccessToken(completed: @Sendable @escaping (Bool) -> Void) {
        tokenRefreshSync.async {
            if self.retryCount >= kRefreshTokenMaxRetryCount {
                DebugPrint.info("Max token refresh retries exceeded.")
                completed(false)
                return
            }

            if self.refreshTokenRequestStatus == .inprogress {
                DebugPrint.info("Refresh token is already in progress.")
                self.pendingTokenRefreshTransactions.append(completed)
                return
            }

            self.refreshTokenRequestStatus = .inprogress
            self.retryCount += 1
        }

        // Actual token refresh happens outside sync to avoid blocking
        self.refreshAuthTokenIfNeeded { accessToken, error in
            self.tokenRefreshSync.async {
                if let error = error as NSError? {
                    if error.code == kBADURL {
                        self.retryCount = kRefreshTokenMaxRetryCount
                        self.refreshTokenRequestStatus = .failed
                        completed(false)
                        return
                    }

                    DebugPrint.info("Token refresh failed. Retrying...")
                    self.refreshTokenRequestStatus = .failed

                    // Exponential backoff / delay can be added here
                    self.tokenRefreshQueue.asyncAfter(deadline: .now() + 1.0) {
                        self.makeRequestToRefreshAccessToken(completed: completed)
                    }
                    return
                }

                DebugPrint.info("Refresh token successful.")

                self.accessToken = accessToken ?? ""
                self.retryCount = 0
                self.refreshTokenRequestStatus = .completed

                // Notify all pending
                for pending in self.pendingTokenRefreshTransactions {
                    pending(true)
                }
                self.pendingTokenRefreshTransactions.removeAll()

                completed(true)
            }
        }
    }

    /// Refresh token
    private func refreshAuthTokenIfNeeded(completeBlock: @escaping ( _ token: String?, _ error: Error?) -> Void) {
        let currentAccessToken = self.oidAuthState?.lastTokenResponse?.accessToken
        if self.oidAuthState == nil {
            self.oidAuthState?.performAction(freshTokens: { (accessToken, _, error) in
                print("error: \(String(describing: error))")
                if currentAccessToken == accessToken {
                    DebugPrint.info("Access token was fresh and not updated.")
                } else {
                    DebugPrint.info("Access token: \(String(describing: accessToken))) was refreshed automatically.")
                }
                completeBlock(accessToken, error)
            })
            completeBlock("", .none)
        }
    }
}

extension AppAuthProvider {
    func deleteCookiesFor(domainName domain: String) {
        URLCache.shared.removeAllCachedResponses()
        let cookies: [HTTPCookie] = HTTPCookieStorage.shared.cookies!
        for item in cookies where item.domain == domain {
            HTTPCookieStorage.shared.deleteCookie(item)
        }
    }

    private func manageRetryCounterValue(newValue: Int) {
        self.retryCount = newValue
        if self.retryCount >= kRefreshTokenMaxRetryCount {
            DebugPrint.info("Reached Maximum retry count:- \(self.retryCount)")
        } else if self.retryCount == 0 {
            DebugPrint.info("Reset retry count value:- \(self.retryCount)")
        }
        DebugPrint.info("Retry count value:- \(self.retryCount)")
    }

    private var isTokenEmpty: Bool {
        return self.accessToken.isEmpty
    }

    func isAuthorizationExpired() -> Bool {
        if !self.isAuthorizedUser() {
            return true
        }
        let accessTokenExpirationDate = self.oidAuthState?.lastTokenResponse?.accessTokenExpirationDate
        let date = Date()
        let result: ComparisonResult  = date.compare(accessTokenExpirationDate!)
        var isExpired: Bool = false
        if result == .orderedDescending {
            isExpired = true
        }
        return isExpired
    }
    func clearAuthState() {
        self.updateOTDAuthState(nil)
    }
}

extension AppAuthProvider {
    func updateOTDAuthState( _ authState: OIDAuthState?) {
        self.oidAuthState = authState
        self.oidAuthState?.stateChangeDelegate = self
        if let authStateItem = authState {
            self.accessToken = authStateItem.lastTokenResponse?.accessToken ?? ""
            self.refreshToken = authStateItem.lastTokenResponse?.refreshToken ?? ""
            self.tokenType = authStateItem.lastTokenResponse?.tokenType ?? ""
            self.scope = authStateItem.lastTokenResponse?.scope ?? ""
            self.accessTokenExpirationDate = authStateItem.lastTokenResponse?.accessTokenExpirationDate ?? Date()
            self.additionalParameters = authStateItem.lastTokenResponse?.additionalParameters ?? [:]
        } else {
            self.accessToken = ""
            self.refreshToken = ""
            self.tokenType = ""
        }
        self.saveState()
    }

    private func saveState() {
        if let authState = self.oidAuthState {
            let wrapper = AuthStateWrapper(authState: authState)
            let success = SecureStoreManager.set(wrapper, forKey: AppAuthKey.kAuthStateInfo)
            DebugPrint.info("Saved auth state: \(success)")
        }
    }

    private func loadState() {
        if let wrapper = SecureStoreManager.get(forKey: AppAuthKey.kAuthStateInfo, as: AuthStateWrapper.self),
           let authState = wrapper.unwrapped() {
            self.oidAuthState = authState
            self.updateOTDAuthState(authState)
            DebugPrint.info("Get auth state: \(authState)")
        }
    }
}

extension AppAuthProvider: OIDAuthStateChangeDelegate {
    func didChange(_ state: OIDAuthState) {
        self.updateOTDAuthState(state)
    }
}

struct AuthStateWrapper: Codable {
    let archivedAuthState: Data?

    init?(authState: OIDAuthState) {
        do {
            self.archivedAuthState = try NSKeyedArchiver.archivedData(withRootObject: authState, requiringSecureCoding: true)
        } catch {
            print("Error archiving authState: \(error)")
            return nil  // Returning nil if archiving fails
        }
    }

    func unwrapped() -> OIDAuthState? {
        guard let data = archivedAuthState else { return nil }
        do {
            return try NSKeyedUnarchiver.unarchivedObject(ofClass: OIDAuthState.self, from: data)
        } catch {
            print("Error unarchiving authState: \(error)")
            return nil  // Returning nil if unarchiving fails
        }
    }
}
