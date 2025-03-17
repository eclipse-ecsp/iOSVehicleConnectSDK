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


final class UserRepositoryTests: XCTestCase {

    override func setUp() {
        super .setUp()
        
    }

    func testUserProfileRepositorySuccess() async {
        let hettpClient: HTTPClientMock =  HTTPClientMock()
        hettpClient.testCaseType = .testGetUserProfileSuccess
        var repositorySut = UserRepository()
        repositorySut.client = hettpClient
        let result = await repositorySut.getUserProfile()
        switch result {
        case .success(let profile):
            XCTAssertNotNil(profile.model.id)
        case .failure:
            XCTFail("GetUserProfile Repository request is failed")
        }
    }
    
    func testUserProfileRepositoryFailed() async {
        let hettpClient: HTTPClientMock =  HTTPClientMock()
        hettpClient.testCaseType = .testGetUserProfilefailed
        var repositorySut = UserRepository()
        repositorySut.client = hettpClient
        let result = await repositorySut.getUserProfile()
        switch result {
        case .success:
            XCTFail("The test is failed because this is request failed case")
        case .failure(let error):
            XCTAssertNotNil(error)
        }
    }
    
    func testSignInWithAppFailed() async {
        let repositorySut = UserRepository()
        AuthManager.shared.authProtocol.accessToken = "4567890-4567890456789rtyuiocfgvhbjksretyui"
        let result = await repositorySut.signInWithAppAuth()
        switch result {
        case .success:
            XCTFail("The signin fail case test is failed")
        case .failure(let error):
            XCTAssertNotNil(error)
        }
    }

    func testRefreshToken() async{
        let repositorySut = UserRepository()
        let result =  await repositorySut.refreshAccessToken()
        switch result {
        case .success(let status):
            XCTAssertTrue(status)
        case .failure:
            XCTFail("refresh token is failed ")

        }
    }
    
    
    func testIsAuthorizationExpired() async{
        let repositorySut = UserRepository()
        let status =  repositorySut.isAuthorizationExpired()
        XCTAssertTrue(status)
    }
    func testSignOutWithAppSuccess() async{
        let repositorySut = UserRepository()
        let result = await repositorySut.signOutWithAppAuth()
        switch result {
        case .success(let status):
            XCTAssertTrue(status)
        case .failure:
            XCTFail(kRequestFailed)
        }
    }
    
}







