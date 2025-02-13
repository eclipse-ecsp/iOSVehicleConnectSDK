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

import XCTest
@testable import VehicleConnectSDK
extension UserServiceable {
    var userRepository: UserRepositoryProtocol {
        get {
            return UserRepositoryMock()
        }
        set {}
    }
}

var accessToken = "XXXXXXXXXXXXXX"
var tokenType = "Bearer"

final class UserServiceTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        AuthManager.shared.authProtocol.accessToken = accessToken
        AuthManager.shared.authProtocol.tokenType = tokenType
    }
    
    func testUserProfileSuccess() async {
        let repository:UserRepositoryProtocol = UserRepositoryMock()
        var serviceSut =  UserService()
        serviceSut.userRepository = repository
        let result = await serviceSut.getUserProfile()
        switch result {
        case .success(let profile):
            XCTAssertNotNil(profile.model.id)
        case .failure:
            XCTFail("Service user proflle failed to get data")
        }
    }
    
    func testSignInWithAppSuccess() async{
        let repository:UserRepositoryProtocol = UserRepositoryMock()
        var serviceSut =  UserService()
        serviceSut.userRepository = repository
        let result = await serviceSut.signInWithAppAuth()
        switch result {
        case .success(let status):
            XCTAssertTrue(status)
        case .failure:
            XCTFail("Service Failed to sign In")
        }
    }
    
    func testSignUPWithAppSuccess() async{
        let repository:UserRepositoryProtocol = UserRepositoryMock()
        var serviceSut =  UserService()
        serviceSut.userRepository = repository
        let result = await serviceSut.signUpWithAppAuth()
            switch result {
            case .success(let status):
                XCTAssertTrue(status)
            case .failure:
                XCTFail("Service Failed to signup")
            }
    }
    
    func testIsAuthorizationExpired() async{
        let repository:UserRepositoryProtocol = UserRepository()
        var serviceSut =  UserService()
        serviceSut.userRepository = repository
        let status =  serviceSut.isAuthorizationExpired()
        XCTAssertTrue(status)
        if status == false{
            XCTFail("Service Failed to autherised")
        }
    }
    
    func testSignOutWithAppSuccess() async{
        let repository:UserRepositoryProtocol = UserRepository()
        var serviceSut =  UserService()
        serviceSut.userRepository = repository
        let result = await serviceSut.signOutWithAppAuth()
        switch result {
        case .success(let status):
            XCTAssertTrue(status)
        case .failure:
            XCTFail("Service failed to signout")
        }
    }
}

//    func testRefreshToken() async{
//        let repository:UserRepositoryProtocol = UserRepositoryMock()
//        var serviceSut =  UserService()
//        serviceSut.userRepository = repository
//        let result = await serviceSut.userRepository.refreshAccessToken()
//        switch result {
//        case .success:
//            XCTFail("The test is failed because this is request failed case")
//        case .failure(let error):
//            XCTAssertNotNil(error)
//        }
//    }




struct UserRepositoryMock: UserRepositoryProtocol {
    
    func signInWithAppAuth() async -> Result<Bool, CustomError> {
        return .success(true)
    }
    
    
    func signUpWithAppAuth() async -> Result<Bool, CustomError> {
        return .success(true)
    }
    
    func signOutWithAppAuth() async -> Result<Bool, CustomError> {
        return .success(true)
    }
    
    func refreshAccessToken() async -> Result<Bool, CustomError> {
        return await AuthManager.shared.authProtocol.refreshAccessToken()
    }
    
    func isAuthorizationExpired() -> Bool {
        return AuthManager.shared.authProtocol.isAuthorizationExpired()
    }
    func getUserProfile() async -> Result<Response<UserProfile>, CustomError> {
        let dataMock = DataMock()
        let result = dataMock.readData(fromFile: "userProfile")
        return await Helper.decoded(result, UserProfile.self)
    }
    
}

extension UserRepository {
    
    func getUserProfile() async -> Result<Response<UserProfile>, CustomError> {
        let result = await client.sendRequest(endpoint: UserEndpoint.profile)
        return await Helper.decoded(result, UserProfile.self)
    }
}
