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

final class NavigationCoordinator<V: Hashable>: ObservableObject {
    @Published var path = NavigationPath()
    var segues: [Identifier : Segue] = [:]
    
    func push(_ value: V) {
        path.append(value)
    }

    func pop() {
        if !path.isEmpty {
            path.removeLast()
            removeInvalidSegues()
        }
    }

    func popToRoot() {
        if !path.isEmpty {
            path.removeLast(path.count)
            segues.removeAll()
        }
    }
    
    func unwind(to identifier: Identifier, with value: Any? = nil) {
        guard let segue = segues[identifier], path.count > segue.index  else { return }
        
        path.removeLast(path.count - segue.index)
        segue.action?(value)
    }
}

extension NavigationCoordinator {
    typealias Identifier = String
    
    struct Segue {
        let index: Int
        let action: ((Any?) -> Void)?
    }
    
    public func registerSegue(with identifier: Identifier, action: ((Any?) -> Void)? = nil) {
        segues[identifier] = Segue(index: path.count, action: action)
    }
    
    private func removeInvalidSegues() {
        segues.keys.forEach { identifier in
            if let segueIndex = segues[identifier]?.index, segueIndex >= path.count {
                segues.removeValue(forKey: identifier)
            }
        }
    }
}
