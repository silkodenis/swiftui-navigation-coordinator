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

public struct RegisterSegueModifier<S: NavigableScreen>: ViewModifier {
    @EnvironmentObject var coordinator: NavigationCoordinator<S>
    
    let type: NavigationCoordinator<S>.Segue.SegueType
    let identifier: String
    let action: ((Any?) -> Void)?
    
    public init(type: NavigationCoordinator<S>.Segue.SegueType, 
                identifier: String, 
                action: ((Any?) -> Void)? = nil) {
        self.type = type
        self.identifier = identifier
        self.action = action
    }
    
    public func body(content: Content) -> some View {
        content.onAppear {
            coordinator.registerSegue(type, with: identifier, action: action)
        }
    }
}