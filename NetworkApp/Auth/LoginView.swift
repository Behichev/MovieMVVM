//
//  LoginView.swift
//  NetworkApp
//
//  Created by Ivan Behichev on 21.04.2025.
//

import SwiftUI

struct LoginView: View {
    
    @StateObject var viewModel: LoginViewModel
    
    init(authService: TMDBAuthServiceProtocol) {
        _viewModel = StateObject(wrappedValue: LoginViewModel(authService: authService))
    }
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.8)
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                
                VStack(spacing: 8) {
                    Text("Login")
                        .font(.largeTitle)
                        .fontWeight(.heavy)
                    
                    TextField("Username", text: $viewModel.username)
                        .padding()
                        .fontWeight(.medium)
                    
                    SecureField("Password", text: $viewModel.password)
                        .fontWeight(.bold)
                        .padding()
                }
                .disableAutocorrection(true)
                .textFieldStyle(.roundedBorder)
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundStyle(.yellow)
                }
                
                Button("Sign In") {
                    viewModel.signIn()
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
        }
    }
}

#Preview {
    let authService = TMDBAuthService()
    LoginView(authService: authService)
}
