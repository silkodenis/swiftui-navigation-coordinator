//
//  GreenBookView.swift
//  Navigation
//
//  Created by Denis Silko on 24.04.2024.
//

import SwiftUI

struct GreenBookView: View {
    @EnvironmentObject var coordinator: Coordinator
    
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
            Text("Stack Navigation:").font(.title)
            
            Button(".push(.blueBook(text: \"🖼️\"))") { coordinator.push(.blueBook(text: "🖼️")) }
                .accessibility(identifier: .pushButton)
            
            Button(".pop()") { coordinator.pop() }
                .accessibility(identifier: .popButton)
            
            Button(".unwind(to: .toOrange)") { coordinator.unwind(to: Screen.toOrange) }
                .accessibility(identifier: .unwindButton)
            
            Button(".popToRoot()") { coordinator.popToRoot() }
                .accessibility(identifier: .popToRootButton)
            
            Text("Modal Presentation:").font(.title)
            
            Button(".present(.orangeBook)") { coordinator.present(.orangeBook) }
                .accessibility(identifier: .presentButton)
            
            Button(".dismiss()") { coordinator.dismiss() }
                .accessibility(identifier: .dismissButton)
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
    }.environmentObject(Coordinator())
}
