//
//  BlueBookView.swift
//  Navigation
//
//  Created by Denis Silko on 24.04.2024.
//

import SwiftUI

struct BlueBookView: View {
    @EnvironmentObject var coordinator: NavigationCoordinator<Screen>
    let text: String
    
    var body: some View {
        content
            .navigationTitle("📘")
    }
    
    var content: some View {
        ZStack {
            Color.indigo.ignoresSafeArea()
            
            VStack {
                Spacer()
                title
                buttons
                Spacer()
                stack
            }
        }
    }

    var title: some View {
        Text(text).font(.largeTitle)
            .accessibility(identifier: .titleText)
    }
    
    var buttons: some View {
        VStack(alignment: .leading, spacing: 10) {
            Button(".pop()") {
                coordinator.pop()
            }.accessibility(identifier: .popButton)
            
            Button(".unwind(to: .redBookSegue, with: \"🔭\")") {
                coordinator.unwind(to: Screen.redBookSegue, with: "🔭")
            }.accessibility(identifier: .unwindButton)
            
            Button(".popToRoot()") {
                coordinator.popToRoot()
            }.accessibility(identifier: .popToRootButton)
        }
        .foregroundColor(.white)
        .bold()
    }
    
    var stack: some View {
        Text("📙-📕-📗-📘")
    }
}

#Preview {
    NavigationStack {
        BlueBookView(text: "🧸")
    }.environmentObject(NavigationCoordinator<Screen>())
}
