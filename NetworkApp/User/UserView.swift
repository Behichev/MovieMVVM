//
//  UserView.swift
//  NetworkApp
//
//  Created by Ivan Behichev on 24.04.2025.
//

import SwiftUI

struct UserView: View {
    
    @EnvironmentObject var authentication: AuthenticationState
    @StateObject var viewModel: UserViewModel
    
    init(repository: UserRepository) {
        _viewModel = StateObject(wrappedValue: UserViewModel(repository: repository))
    }
 
    var body: some View {
        VStack(spacing: 16) {
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


