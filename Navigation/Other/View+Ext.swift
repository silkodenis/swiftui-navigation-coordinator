//
//  View+Ext.swift
//  Navigation
//
//  Created by Denis Silko on 27.04.2024.
//

import SwiftUI

extension View {
    func accessibility(identifier: AccessibilityID) -> some View {
        self.accessibility(identifier: identifier.rawValue)
    }
}
