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

/// Remote operation update command status type
public enum RemoteCommandStatus: String, Codable {
    case success = "PROCESSED_SUCCESS"
    case pending  = "PENDING"
    case ttlExpired  = "TTL_EXPIRED"
    case failed = "PROCESSED_FAILED"
}

/// Remote operation history mode;
public struct RemoteEventHistory: Codable {
  public let roEvent: RemoteEvent
  public let roStatus: RemoteCommandStatus?

}

/// Remote operation evnet
public struct RemoteEvent: Codable {
    public let eventId, version: String
    public let timestamp: Int
    public let roDetail: RemoteEventDetail

    enum CodingKeys: String, CodingKey {
        case eventId = "EventID"
        case version = "Version"
        case timestamp = "Timestamp"
        case roDetail = "Data"
    }

}

///  Remote operation event detail
public struct RemoteEventDetail: Codable {
    public  let state: String
    public let duration, percent: Int?
    public let roRequestId: String

}
