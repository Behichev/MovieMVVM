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
        Group {
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
                        
                        if let errorMessage = viewModel.errorMessage {
                            Text(errorMessage)
                                .foregroundColor(.red)
                        }
                        HStack {
                            if viewModel.isPasswordVisible {
                                TextField("Password", text: $viewModel.password)
                                    .padding()
                                    .fontWeight(.bold)
                            } else {
                                SecureField("Password", text: $viewModel.password)
                                    .fontWeight(.bold)
                                    .padding()
                            }
                            Image(systemName: viewModel.isPasswordVisible ? "eye.slash.fill" : "eye.fill")
                                .onTapGesture {
                                    viewModel.isPasswordVisible.toggle()
                                }
                        }
                    }
                    .disableAutocorrection(true)
                    .textFieldStyle(.roundedBorder)
                    .padding()
                    .background {
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundStyle(.yellow)
                    }
                    
                    Button("Sign In") {
                        viewModel.checkValidation()
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(viewModel.isLoggingDisabled)
                    .opacity((viewModel.username.isEmpty || viewModel.password.isEmpty) ? 0.5 : 1.0)
                }
                .padding()
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
}


#Preview {
    let authService = AccountService()
    LoginView(authService: authService)
}
