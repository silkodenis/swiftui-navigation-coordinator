/*
 * Copyright (c) [2024] [Denis Silko]
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import SwiftUI
import NavigationCoordinator

enum Screen {
    case orangeBook
    case redBook
    case greenBook
    case blueBook(text: String)
    
    /// Used to uniquely identify segues that either navigate back to a previous screen or dismiss a modal view.
    static let toBlue = "toBlue"
    static let toOrange = "toOrange"
    static let toRed = "toRed"
}

extension Screen: NavigableScreen {
    @ViewBuilder
    var view: some View {
        switch self {
        case .orangeBook: OrangeBookView()
        case .redBook: RedBookView()
        case .greenBook: GreenBookView()
        case .blueBook(let text): BlueBookView(text: text)
        }
    }
}
