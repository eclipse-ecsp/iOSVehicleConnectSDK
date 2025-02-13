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

/// For  printing the debug message
public enum DebugPrint {
    public static func message(_ text: String,
                               _ fileName: String = #file, _ function: String = #function, _ line: Int = #line) {
#if DEBUG
        print("\(text) \t fileName:\((fileName as NSString).lastPathComponent), function:\(function), line no:\(line)")
#endif
    }
}
