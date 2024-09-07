//
//  View+Ext.swift
//  Navigation
//
//  Created by Denis Silko on 27.04.2024.
//

import SwiftUI

// MARK: - Accessibility Identifier

extension View {
    func accessibility(identifier: AccessibilityID) -> some View {
        self.accessibility(identifier: identifier.rawValue)
    }
}

// MARK: - Segue Modifier

extension View {
    func onUnwind(segue identifier: String, perform action: ((Any?) -> Void)? = nil) -> some View {
        modifier(SegueModifier(type: .unwind, identifier: identifier, action: action))
    }
    
    func onDismiss(segue identifier: String, perform action: ((Any?) -> Void)? = nil) -> some View {
        modifier(SegueModifier(type: .dismiss, identifier: identifier, action: action))
    }
}
