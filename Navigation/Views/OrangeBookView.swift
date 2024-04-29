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
            .onUnwind(segue: Screen.orangeBookSegue)
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
        Button(".push(.redBook)") { coordinator.push(.redBook) }
            .accessibility(identifier: .pushButton)
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
