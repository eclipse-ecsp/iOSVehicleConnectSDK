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

/// HTTPClient  process the api request and return the raw data response
public protocol HTTPClientProtocol {
    func sendRequest(endpoint: Endpoint) async -> Result<Data, NetworkError>
}

class HTTPClient: HTTPClientProtocol {

    /// This method is used to create request
    /// - Parameter endpoint: Used for base url, path, header and body
    /// - Returns: Return response data and error
    public func sendRequest(endpoint: Endpoint) async -> Result<Data, NetworkError> {
        let urlString = endpoint.baseUrl + endpoint.path
        DebugPrint.info("URL: \(urlString)")
        guard urlString.isValidURL, let url = URL(string: urlString) else {
            return .failure(.invalidURL)
        }
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        if let httpHeader = endpoint.header {
            request.allHTTPHeaderFields = httpHeader
            DebugPrint.info("Headers: \(httpHeader)")
        }
        if let body = endpoint.body {
            request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
            DebugPrint.info("Body: \(body)")
        }
        return await send(request)
    }

    /// This method is used to call api and handle data
    /// - Parameter request: Url request
    /// - Returns: Return response data and error
    private func send(_ request: URLRequest) async -> Result<Data, NetworkError> {
        do {
            DebugPrint.info("Request: \(request)")
            let (data, response) = try await URLSession.shared.data(for: request, delegate: nil)
            
//            let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
//            DebugPrint.info("Response: \(jsonObject)")
            
            guard let response = response as? HTTPURLResponse else {
                return .failure(.noResponse)
            }
            switch response.statusCode {
            case 200...205:
                return .success(data)
            case 401:
                return .failure(.unauthorized)
            default:
                if data.isEmpty {
                    return .failure(.unexpectedStatusCode)
                }
                return .failure(.dataValidation(data))
            }
        } catch {
            return .failure(.unknown(error.localizedDescription))
        }
    }
}
