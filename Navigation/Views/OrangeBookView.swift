//
//  OrangeBookView.swift
//  Navigation
//
//  Created by Denis Silko on 24.04.2024.
//

import SwiftUI

struct OrangeBookView: View {
    @EnvironmentObject var coordinator: NavigationCoordinator<Screen>
    
    var body: some View {
        content
            .navigationTitle("📙")
            .onUnwind(segue: Screen.toOrange)
    }
    
    var content: some View {
        ZStack {
            Color.orange.ignoresSafeArea()
            
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
            
            Button(".push(.redBook)") { coordinator.push(.redBook) }
                .accessibility(identifier: .pushButton)
            
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
        Text("📙")
    }
}

#Preview {
    NavigationStack {
        OrangeBookView()
    }.environmentObject(NavigationCoordinator<Screen>())
}
