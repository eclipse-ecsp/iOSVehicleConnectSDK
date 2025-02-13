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

///  Remote operation event type
public enum RemoteEventStateType: String {
    case alarm
    case windows
    case lights
    case trunk
    case doors
    case engine
    case horn
    case alarmSignal
}

///  Remote operation event state
public enum RemoteEventStateValue: String {

    case stateOn = "ON"
    case stateOff = "OFF"
    case flash = "FLASH"
    case locked = "LOCKED"
    case unlocked = "UNLOCKED"
    case stopped = "STOPPED"
    case started = "STARTED"
    case closed = "CLOSED"
    case opened = "OPENED"
    case ajar = "PARTIAL_OPENED"

}

/// Remote Operation history request
public struct RemoteOperationHistoryRequest {
      let userId: String
      let vehicleId: String

    public init(userId: String, vehicleId: String) {
        self.userId = userId
        self.vehicleId = vehicleId
    }
}
