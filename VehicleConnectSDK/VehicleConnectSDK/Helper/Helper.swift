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

/// Helper class is the  class the contains the utility functions
struct Helper {
    static var deviceLocale: String {
        var deviceCurrentLocale = "en-US"
        if let devicePrefferedLocaleId: String =  Locale.preferredLanguages.first {
            let deviceLocale = Locale(identifier: devicePrefferedLocaleId)
            deviceCurrentLocale = deviceLocale.identifier
        }
        return deviceCurrentLocale
    }
    static func randomString(length: Int) -> String {
      let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      return String((0..<length).map { _ in letters.randomElement()! })
    }

    /// This is generic function that convert the json object to the  requested type model object
    static func decoded<T: Decodable>(_ result: Result<Data, NetworkError>, _ responseModel: T.Type)
    async -> Result<Response<T>, CustomError> {
        switch result {
        case .success(let responseData):
            guard let decodedResponse = try? JSONDecoder().decode(responseModel, from: responseData) else {
                return .failure(.decode)
            }
            let respone = Response(data: responseData, model: decodedResponse)
            return .success(respone)
        case .failure(let error):
            switch error {
            case .dataValidation(let data):

                if let errorResp = try? JSONDecoder().decode([DataError].self, from: data) {
                    let errorObj = errorResp[0]
                    return .failure(.generic(errorObj.message))
                }
                if let resp = try? JSONDecoder().decode(DataError.self, from: data) {
                    return .failure(.generic(resp.message))
                }
                return .failure(.networkError(error))
            default:
                return .failure(.networkError(error))
            }
        }
    }

}
