//
//  LoginView.swift
//  NetworkApp
//
//  Created by Ivan Behichev on 21.04.2025.
//

import SwiftUI

struct LoginView: View {
    
    @StateObject var viewModel: LoginViewModel
    @EnvironmentObject var authentication: Authentication
    
    init(authService: TMDBAuthService) {
        _viewModel = StateObject(wrappedValue: LoginViewModel(authService: authService))
    }
    
    var body: some View {
            ZStack {
                
                VStack(spacing: 24) {
                    
                    VStack(spacing: 8) {
                        Text("Login")
                            .font(.largeTitle)
                            .fontWeight(.heavy)
                        
                        TextField("Username", text: $viewModel.credentials.username)
                            .padding()
                            .fontWeight(.medium)
                        
                        if let errorMessage = viewModel.errorMessage {
                            Text(errorMessage)
                                .foregroundColor(.red)
                        }
                        HStack {
                            if viewModel.isPasswordVisible {
                                TextField("Password", text: $viewModel.credentials.password)
                                    .padding()
                                    .fontWeight(.bold)
                            } else {
                                SecureField("Password", text: $viewModel.credentials.password)
                                    .fontWeight(.bold)
                                    .padding()
                            }
                            Image(systemName: viewModel.isPasswordVisible ? "eye.slash.fill" : "eye.fill")
                                .onTapGesture {
                                    withAnimation {
                                        viewModel.isPasswordVisible.toggle()
                                    }
                                    
                                }
                        }
                    }
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .textFieldStyle(.roundedBorder)
                    .padding()
                    
                    Button("Sign In") {
                        Task {
                            do {
                                try await viewModel.checkValidation()
                                await authentication.checkSession()
                                authentication.isAuthenticated = true
                            } catch {
                                viewModel.authState = .login
                                throw error
                            }
                            
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(viewModel.isLoggingDisabled)
                    .opacity(viewModel.isLoggingDisabled ? 0.5 : 1.0)
                }
            }
            .overlay {
                if viewModel.authState == .loading {
                    withAnimation {
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .foregroundStyle(.black.opacity(0.7))
                                .frame(width: 100, height: 100)
                            
                            ProgressView()
                                .progressViewStyle(.circular)
                                .tint(.yellow)
                        }
                    }
                }
            }
        
    }
}


#Preview {
    let authService = AccountService()
    LoginView(authService: authService)
}
