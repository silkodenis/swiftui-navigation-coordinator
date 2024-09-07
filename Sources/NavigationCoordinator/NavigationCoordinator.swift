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

public protocol NavigableScreen: Hashable, Identifiable {
    associatedtype ContentView: View
    @ViewBuilder var view: ContentView { get }
}

public extension NavigableScreen {
    var id: UUID { UUID() }
}

public final class NavigationCoordinator<Screen: NavigableScreen>: ObservableObject {
    @Published var path = NavigationPath()
    @Published var parent: NavigationCoordinator<Screen>?
    @Published var modal: Screen?
    var segues: [Identifier : Segue] = [:]
    
    public init(parent: NavigationCoordinator<Screen>? = nil, modal: Screen? = nil) {
        self.parent = parent
        self.modal = modal
    }
    
    // MARK: - Stack Navigation
    
    public func push(_ value: Screen) {
        path.append(value)
    }
    
    public func pop() {
        if !path.isEmpty {
            path.removeLast()
            removeInvalidSegues()
        }
    }

    public func popToRoot() {
        if !path.isEmpty {
            path.removeLast(path.count)
            segues.removeAll()
        }
    }
    
    public func unwind(to identifier: Identifier, with value: Any? = nil) {
        guard let segue = segues[identifier], path.count > segue.index, segue.type == .unwind else { return }
        
        path.removeLast(path.count - segue.index)
        segue.action?(value)
    }
    
    // MARK: - Modal Presentation
    
    public func present(_ value: Screen) {
        modal = value
    }
    
    public func dismiss(to identifier: Identifier? = nil, with value: Any? = nil) {
        guard let identifier = identifier, let segue = parent?.segues[identifier],
                segue.type == .dismiss else {
            parent?.modal = nil
            return
        }
        
        parent?.modal = nil
        segue.action?(value)
    }
}

public extension NavigationCoordinator {
    typealias Identifier = String
    
    struct Segue {
        let type: SegueType
        let index: Int
        let action: ((Any?) -> Void)?
        
        public enum SegueType {
            case unwind
            case dismiss
        }
    }
    
    internal func registerSegue(_ type: Segue.SegueType, with identifier: Identifier, action: ((Any?) -> Void)? = nil) {
        segues[identifier] = Segue(type: type, index: path.count, action: action)
    }
    
    private func removeInvalidSegues() {
        segues.keys.forEach { identifier in
            if let segueIndex = segues[identifier]?.index, segueIndex >= path.count {
                segues.removeValue(forKey: identifier)
            }
        }
    }
}
