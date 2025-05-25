//
//  UserView.swift
//  NetworkApp
//
//  Created by Ivan Behichev on 24.04.2025.
//

import SwiftUI

struct UserView: View {
    
    @EnvironmentObject var authentication: AuthenticationStore
    @ObservedObject var viewModel: UserViewModel
 
    var body: some View {
        VStack(spacing: Constants.Design.LayoutConstants.defaultSpacing.rawValue) {
            if let user = viewModel.user {
                VStack {
                    UserAvatarView(url: viewModel.avatarURL, size: 120)
                    Text(user.username)
                        .font(.largeTitle)
                        .bold()
                    
                    Button("Log Out") {
                        Task {
                            await authentication.logout()
                        }
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
        }
        .padding()
        .task {
            try? await viewModel.fetchUser()
        }
    }
}


