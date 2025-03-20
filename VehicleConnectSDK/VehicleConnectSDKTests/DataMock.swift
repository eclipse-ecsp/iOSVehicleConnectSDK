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


@testable import VehicleConnectSDK


extension RemoteOperationRepositoryProtocol {
    var httpClient: HTTPClientMock {
        get {
            return HTTPClientMock()
        }
        set {}
    }
}

extension VehicleRepositoryProtocol {
    var httpClient: HTTPClientMock {
        get {
            return HTTPClientMock()
        }
        set {}
    }
}

extension NotificationRepositoryProtocol {
    var httpClient: HTTPClientMock {
        get {
            return HTTPClientMock()
        }
        set {}
    }
}


enum TestCaseType {
    case testGetROHistorySuccess
    case testGetROHistoryFailed
    case testGetROCommandSuccess
    case testGetROCommandFailed
    case testSetROCommandSuccess
    case testSetROCommandFailed
    case testSignInSuccess
    case testSignInFailed
    case testSignUpSuccess
    case testSignUpFailed
    case testSignoutSuccess
    case testSignOutfailed
    case testGetUserProfileSuccess
    case testGetUserProfilefailed
    case testRefreshTokenSuccess
    case testRefreshTokenFailed
    case testGetVehicleProfileSuccess
    case testGetVehicleProfileFailed
    case testUpdateVehicleProfileSuccess
    case testUpdateVehicleProfileFailed
    case testGetAssociatedVehiclesSuccess
    case testGetAssociatedVehicleFailed
    case testValidateImeiSuccess
    case testValidateIMEIFailed
    case testAddDeviceSuccess
    case testAddDeviceFailed
    case testRemoveDeviceSuccess
    case testRemoveDeviceFailed
    case testShareDeviceTokenSuccess
    case testShareDeviceTokenFailed
    case testGetAlertsHistorySuccess
    case testGetAlertsHistoryFailed
    
}

class DataMock {
     func readData(fromFile name: String, ext: String = "json") -> Result<Data, NetworkError>  {
       let data =  self.getJsonData(fromFile: name)
        return .success(data)
    }
    func getJsonData(fromFile name: String, ext: String = "json") -> Data {
        let bundle = Bundle(for: Self.self)
        let url = bundle.url(forResource: name, withExtension: ext)!
        guard let data = try? Data(contentsOf: url) else { return Data() }
        return data
    }
    
}

class HTTPClientMock: HTTPClientProtocol {
    var testCaseType:TestCaseType?
    
    func sendRequest(endpoint: any Endpoint) async -> Result<Data, NetworkError> {
        
        let urlString = endpoint.baseUrl + endpoint.path
        DebugPrint.message("URL: \(urlString)")
        guard let url = URL(string: urlString) else {
            return .failure(.invalidURL)
        }
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        if let httpHeader = endpoint.header {
            request.allHTTPHeaderFields = httpHeader
            DebugPrint.message("Headers: \(httpHeader)")
        }
        if let body = endpoint.body {
            request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
            DebugPrint.message("Body: \(body)")
        }
        
        return await send(request)
    }
    
    private func send(_ request: URLRequest) async -> Result<Data, NetworkError> {
            let dataMock = DataMock()
            switch testCaseType {
            case .testGetROHistorySuccess:
                return.success(dataMock.getJsonData(fromFile: "roHistory"))
            case .testGetROHistoryFailed:
                return.failure(.unauthorized)
            case .testGetROCommandSuccess:
                return.success(dataMock.getJsonData(fromFile: "roEventStatus"))
            case .testGetROCommandFailed:
                return.failure(.invalidURL)
            case .testSetROCommandSuccess:
                return.success(dataMock.getJsonData(fromFile: "roEventUpdate"))
            case .testSetROCommandFailed:
                return.failure(.unexpectedStatusCode)
            case .testGetUserProfileSuccess:
                return.success(dataMock.getJsonData(fromFile: "userProfile"))
            case .testGetUserProfilefailed:
                return.failure(.unexpectedStatusCode)
            case .testGetVehicleProfileSuccess:
                return.success(dataMock.getJsonData(fromFile: "vehicleProfile"))
            case .testGetVehicleProfileFailed:
                return.failure(.invalidURL)
            case .testUpdateVehicleProfileSuccess:
                return.success(dataMock.getJsonData(fromFile: "updateProfile"))
            case .testUpdateVehicleProfileFailed:
                return.failure(.unexpectedStatusCode)
            case .testGetAssociatedVehiclesSuccess:
                return.success(dataMock.getJsonData(fromFile: "vehicleAssociationsList"))
            case .testGetAssociatedVehicleFailed:
                return.failure(.unexpectedStatusCode)
            case .testValidateImeiSuccess:
                return.success(dataMock.getJsonData(fromFile: "validateImei"))
            case .testValidateIMEIFailed:
                return.failure(.unexpectedStatusCode)
            case .testAddDeviceSuccess:
                return.success(dataMock.getJsonData(fromFile: "associateDevice"))
            case .testAddDeviceFailed:
                return.failure(.unexpectedStatusCode)
            case .testRemoveDeviceSuccess:
                return.success(dataMock.getJsonData(fromFile: "terminareDevice"))
            case .testRemoveDeviceFailed:
                return.failure(.unexpectedStatusCode)
            case .testShareDeviceTokenSuccess:
                return.success(dataMock.getJsonData(fromFile: "shareDeviceToken"))
            case .testShareDeviceTokenFailed:
                return.failure(.unexpectedStatusCode)
            case .testGetAlertsHistorySuccess:
                return.success(dataMock.getJsonData(fromFile: "alertsHistory"))
            case .testGetAlertsHistoryFailed:
                return.failure(.unauthorized)
            case .testSignInSuccess:
                return.success(dataMock.getJsonData(fromFile: "ROHistory"))
            case .testSignInFailed:
                return.failure(.unexpectedStatusCode)
            case .testSignUpSuccess:
                return.success(dataMock.getJsonData(fromFile: "ROHistory"))
            case .testSignUpFailed:
                return.failure(.unexpectedStatusCode)
            case .testSignoutSuccess:
                return.success(dataMock.getJsonData(fromFile: "ROHistory"))
            case .testSignOutfailed:
                return.failure(.unexpectedStatusCode)
            case .testRefreshTokenSuccess:
                return.success(dataMock.getJsonData(fromFile: "ROHistory"))
            case .testRefreshTokenFailed:
                return.failure(.unexpectedStatusCode)
            case .none:
                return.failure(.unexpectedStatusCode)
            }
    }
    
    
}

extension URLSession {

      func data(for request: URLRequest, delegate: (any URLSessionTaskDelegate)? = nil) async throws -> (Data, URLResponse) {
          let urlResponse :  URLResponse = URLResponse.init(url: request.url!, mimeType: .none, expectedContentLength: .max, textEncodingName: "mockapi")
          let dataMock = DataMock()
          let data = dataMock.getJsonData(fromFile: "roHistory")
          return (data, urlResponse)
          
              }
}
