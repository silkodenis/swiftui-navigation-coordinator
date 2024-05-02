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

enum Screen: Hashable {
    case orangeBook
    case redBook
    case greenBook
    case blueBook(text: String)
}

extension Screen: Identifiable {
    var id: Int { self.hashValue }
}

extension Screen {
    // Dismiss segue identifiers
    static let blueDismiss = "blueDismiss"
    
    // Unwind segue identifiers
    static let orangeBookSegue = "unwindToOrangeBook"
    static let redBookSegue = "unwindToRedBook"
}

extension Screen {
    @ViewBuilder
    var view: some View {
        switch self {
        case .orangeBook:
            OrangeBookView()
            
        case .redBook:
            RedBookView()
            
        case .greenBook:
            GreenBookView()
            
        case .blueBook(let text):
            BlueBookView(text: text)
        }
    }
}