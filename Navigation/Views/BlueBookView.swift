//
//  BlueBookView.swift
//  Navigation
//
//  Created by Denis Silko on 24.04.2024.
//

import SwiftUI

struct BlueBookView: View {
    @EnvironmentObject var coordinator: NavigationCoordinator<Screen>
    @State var dismissValue = ""
    let text: String
    
    var body: some View {
        content
            .navigationTitle("📘")
            .onDismiss(segue: Screen.blueDismiss) { value in
                guard let value = value as? String else { return }
                dismissValue = value
            }
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
        Text(text + dismissValue).font(.largeTitle)
            .accessibility(identifier: .titleText)
    }
    
    var buttons: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Stack Navigation:").font(.title)
            
            Button(".pop()") { coordinator.pop() }
                .accessibility(identifier: .popButton)
            
            Button(".unwind(to: .redBookSegue, with: \"🔭\")") {
                coordinator.unwind(to: Screen.redBookSegue, with: "🔭")
            }.accessibility(identifier: .unwindButton)
            
            Button(".popToRoot()") { coordinator.popToRoot() }
                .accessibility(identifier: .popToRootButton)
            
            Text("Modal Presentation:").font(.title)
            
            Button(".present(.orangeBook)") { coordinator.present(.orangeBook) }
                .accessibility(identifier: .presentButton)
            
            Button(".dismiss(to: .blueDismiss, with: \"🧸\")") {
                coordinator.dismiss(to: Screen.blueDismiss, with: "🧸")
            }.accessibility(identifier: .dismissButton)
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
