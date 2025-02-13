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
extension AppAuthProvider {
    func signIn() async -> Result<Bool, CustomError> {
        return await authentication(forSignIn: true)
    }

    func signUp() async -> Result<Bool, CustomError> {
        return await authentication(forSignIn: false)
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
        if NetworkManager.shared.isConnected {
            return await withCheckedContinuation { continuation in
                makeRequestToRefreshAccessToken { isSuccess in
                    continuation.resume(returning: isSuccess ? .success(true) : .failure(.refreshTokenFailed))
                }
            }
        } else {
            return .failure(.notRechable)
        }
    }
///   Making the authentication call on signin click
    private func authentication(forSignIn: Bool) async -> Result<Bool, CustomError> {

        if NetworkManager.shared.isConnected {
            if let environment = AppManager.environment {
                let baseUrl = forSignIn ? environment.signInUrl : environment.signUpUrl
                let authEndpoint = baseUrl + (forSignIn ? UserEndpoint.signIn.path : UserEndpoint.signUp.path)
                let tokenEndpoint = baseUrl + UserEndpoint.authToken.path

                if self.accessToken.isEmpty {
                    return await withCheckedContinuation { continuation in
                        self.authenticate(environment: environment, authEndpoint: authEndpoint,
                                          tokenEndpoint: tokenEndpoint) { isSuccess in
                            continuation.resume(returning: isSuccess ? .success(true) : .failure(.emptyToken))
                        }
                    }
                } else {
                    return .failure(.alreadySignin)
                }
            } else {
                return .failure(.environmentNotConfigured)
            }
        } else {
            return .failure(.notRechable)
        }
    }

///  Authenticate function to create auth request
    private func authenticate(environment: EnvironmentDetail, authEndpoint: String, tokenEndpoint: String,
                              _ handler: @escaping(_ isSuccess: Bool) -> Void) {
        guard let authUrl = URL.init(string: authEndpoint),
              let tokenUrl = URL.init(string: tokenEndpoint),
              let redirectUrl = URL.init(string: environment.redirectUrl),
              let rootViewController = UIApplication.shared.rootViewController else { return }

        let additionalParams = [AppAuthKey.kAuthorizationGrant: OIDGrantTypeAuthorizationCode,
                                AppAuthKey.kAuthorizationPrompt: AppAuthKey.kAuthorizationLogin,
                                AppAuthKey.kLocale: String(Helper.deviceLocale.split(separator: "-").first!) ]

        let configuration = OIDServiceConfiguration(authorizationEndpoint: authUrl, tokenEndpoint: tokenUrl)

        let request = OIDAuthorizationRequest(configuration: configuration, clientId: environment.clientId,
                                              clientSecret: environment.clientSecret, scopes: environment.scopes,
                                              redirectURL: redirectUrl, responseType: OIDResponseTypeCode,
                                              additionalParameters: additionalParams)

        DebugPrint.message("App auth request: \(request)")
        currentAuthorizationFlow = OIDAuthState.authState(byPresenting: request,
                                                          presenting: rootViewController) {[weak self] authState, _ in
            if let authState = authState {
                self?.updateOTDAuthState(authState)
                handler(true)
            } else {
                self?.updateOTDAuthState(nil)
                handler(false)
            }
        }
    }
///   Refresh token api call
    private func makeRequestToRefreshAccessToken(completed: @escaping(_ isSuccess: Bool) -> Void) {
        if self.retryCount >= kRefreshTokenMaxRetryCount {
            DebugPrint.message("We tried maximum to refresh token but request keep failing.")
            completed(false)
            return
        }
        if refreshTokenRequestStatus  == .inprogress {
            DebugPrint.message("Refreh token request is in Progess. Hence not requesting again.")
            pendingTokenRefreshTransactions.append(completed)
            return
        }
        refreshTokenRequestStatus = .inprogress
        let lockQueue = DispatchQueue(label: "com.test.LockQueue")
        lockQueue.sync {
            self.manageRetryCounterValue(newValue: retryCount + 1)
            self.refreshAuthTokenIfNeeded { (accessToken, error) in
                if error == nil {
                    DebugPrint.message("Refresh token request completed")
                  /**
                  * To Do: Ensure the accessToken is not printed anywhere 
                  */
                    self.manageRetryCounterValue(newValue: 0)
                    self.accessToken = accessToken ?? ""
                    for completion in self.pendingTokenRefreshTransactions {
                        completion(true)
                    }
                    self.refreshTokenRequestStatus = .completed
                    completed(true)
                } else {
                    let nsError = error as NSError?
                    if nsError?.code == kBADURL {
                        self.manageRetryCounterValue(newValue: kRefreshTokenMaxRetryCount)
                        completed(false)
                        return
                    }
                    DebugPrint.message("Refresh Token request has been failed. Hence resending again.")
                    self.refreshTokenRequestStatus = .failed
                    self.makeRequestToRefreshAccessToken(completed: { (_) in })
                }
            }
        }
    }
/// Refresh token 
    private func refreshAuthTokenIfNeeded(completeBlock: @escaping ( _ token: String?, _ error: Error? ) -> Void) {
        let currentAccessToken = self.oidAuthState?.lastTokenResponse?.accessToken
        if self.oidAuthState == nil {
            self.oidAuthState?.performAction(freshTokens: { (accessToken, _, error) in
                print("error: \(String(describing: error))")
                if currentAccessToken == accessToken {
                    DebugPrint.message("Access token was fresh and not updated.")
                } else {
                    DebugPrint.message("Access token: \(String(describing: accessToken))) was refreshed automatically.")
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
            DebugPrint.message("Reached Maximum retry count:- \(self.retryCount)")
        } else if self.retryCount == 0 {
            DebugPrint.message("Reset retry count value:- \(self.retryCount)")
        }
        DebugPrint.message("Retry count value:- \(self.retryCount)")
    }

    private var isTokenEmpty: Bool {
        return self.accessToken.isEmpty || self.accessToken.count == 0
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
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: self.oidAuthState ?? "",
                                                        requiringSecureCoding: false)
            _ = SecureStoreManager.set(data: data, forKey: AppAuthKey.kAuthStateInfo)
        } catch { }
    }

    private func loadState() {
        guard let data =  SecureStoreManager.getData(key: AppAuthKey.kAuthStateInfo) else { return }
        guard let authState = try? NSKeyedUnarchiver.unarchivedObject(ofClass: OIDAuthState.self,
                                                                      from: data) else { return }
        self.updateOTDAuthState(authState)
    }
}

extension AppAuthProvider: OIDAuthStateChangeDelegate {
    func didChange(_ state: OIDAuthState) {
        self.updateOTDAuthState(state)
    }
}
