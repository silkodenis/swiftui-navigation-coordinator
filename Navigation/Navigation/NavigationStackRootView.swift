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

struct NavigationStackRootView<S: NavigableScreen>: View {
    @ObservedObject private var coordinator: NavigationCoordinator<S>
    private let root: S
    
    internal init(_ root: S, withParent coordinator: NavigationCoordinator<S>? = nil) {
        self.root = root
        self.coordinator = NavigationCoordinator<S>()
        self.coordinator.parent = coordinator
    }
    
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            root.view
                .navigationDestination(for: S.self) { screen in
                    screen.view
                }
        }
        .sheet(item: $coordinator.modal) { screen in
            NavigationStackRootView(screen, withParent: coordinator)
        }
        .environmentObject(coordinator)
    }
}
