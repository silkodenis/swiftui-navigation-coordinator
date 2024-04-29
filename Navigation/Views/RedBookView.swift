//
//  RedBookView.swift
//  Navigation
//
//  Created by Denis Silko on 24.04.2024.
//

import SwiftUI

struct RedBookView: View {
    @EnvironmentObject var coordinator: NavigationCoordinator<Screen>
    @State private var text: String = ""
    
    var body: some View {
        content
            .navigationTitle("📕")
            .onUnwind(segue: Screen.redBookSegue) { text in
                guard let text = text as? String else { return }
                self.text = text
            }
    }
    
    var content: some View {
        ZStack {
            Color.pink.ignoresSafeArea()
            
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
            Button(".push(.greenBook)") {coordinator.push(.greenBook)}
                .accessibility(identifier: .pushButton)
            
            Button(".pop()") { coordinator.pop()}
                .accessibility(identifier: .popButton)
            
            Button(".unwind(to: .orangeBookSegue)") { coordinator.unwind(to: Screen.orangeBookSegue)}
                .accessibility(identifier: .unwindButton)
            
            Button(".popToRoot()") {coordinator.popToRoot()}
                .accessibility(identifier: .popToRootButton)
        }
        .foregroundColor(.white)
        .bold()
    }
    
    var stack: some View {
        Text("📙-📕")
    }
}

#Preview {
    NavigationStack {
        RedBookView()
    }.environmentObject(NavigationCoordinator<Screen>())
}
