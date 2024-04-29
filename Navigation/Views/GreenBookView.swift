//
//  GreenBookView.swift
//  Navigation
//
//  Created by Denis Silko on 24.04.2024.
//

import SwiftUI

struct GreenBookView: View {
    @EnvironmentObject var coordinator: NavigationCoordinator<Screen>
    
    var body: some View {
        content
            .navigationTitle("📗")
    }
    
    var content: some View {
        ZStack {
            Color.green.ignoresSafeArea()
            
            VStack {
                Spacer()
                buttons
                Spacer()
                stack
            }
        }
    }
    
    var buttons: some View {
        VStack(alignment: .leading, spacing: 10) {
            Button(".push(.blueBook(text: \"🖼️\"))") { coordinator.push(.blueBook(text: "🖼️")) }
                .accessibility(identifier: .pushButton)
            
            Button(".pop()") { coordinator.pop() }
                .accessibility(identifier: .popButton)
            
            Button(".unwind(to: .orangeBookSegue)") { coordinator.unwind(to: Screen.orangeBookSegue) }
                .accessibility(identifier: .unwindButton)
            
            Button(".popToRoot()") { coordinator.popToRoot() }
                .accessibility(identifier: .popToRootButton)
        }
        .foregroundColor(.white)
        .bold()
    }
    
    var stack: some View {
        Text("📙-📕-📗")
    }
}

#Preview {
    NavigationStack {
        GreenBookView()
    }.environmentObject(NavigationCoordinator<Screen>())
}
