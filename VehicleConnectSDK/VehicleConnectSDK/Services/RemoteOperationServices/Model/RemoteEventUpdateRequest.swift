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

/// Remote operation update request
public struct RemoteEventUpdateRequest {

    let userId: String
    let vehicleId: String
    let stateType: RemoteEventStateType?
    let postData: RemoteEventUpdateData?

    public init(userId: String, vehicleId: String, stateType: RemoteEventStateType?, postData: RemoteEventUpdateData?) {
        self.userId = userId
        self.vehicleId = vehicleId
        self.stateType = stateType
        self.postData = postData
    }
}

/// Upadte request post params
public struct RemoteEventUpdateData {
    let state: RemoteEventStateValue
    let percent: Int?
    let duration: Int?

    public init(state: RemoteEventStateValue, percent: Int?, duration: Int?) {
        self.state = state
        self.percent = percent
        self.duration = duration
    }

    public var param: [String: Any] {
        if let percent = percent, let duration = duration {
            return ["state": state.rawValue, "percent": percent, "duration": duration]
        } else if let duration = duration {
            return ["state": state.rawValue, "duration": duration]
        } else {
            return ["state": state.rawValue]
        }
    }
}
