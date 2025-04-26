//
//  AccountView.swift
//  NetworkApp
//
//  Created by Ivan Behichev on 24.04.2025.
//

import SwiftUI

struct AccountView: View {
    
    @EnvironmentObject var authentication: Authentication

    var body: some View {
        VStack {
            Text("User Name")
            Button("Log Out") {
                Task {
                  await authentication.logout()
                }
            }
            .buttonStyle(.borderedProminent)
        }
    }
}

#Preview {
    AccountView()
}
