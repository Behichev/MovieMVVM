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
    
    enum Assets: String {
        case userImage = "person.fill"
        case passwordImage = "lock.fill"
    }
    
    var body: some View {
        switch viewModel.authState {
        case .login:
            authView
        case .loading:
            authView
                .overlay {
                    withAnimation {
                        LoaderView()
                    }
                }
        case .error(let errorMessage):
            ZStack {
                VStack {
                    ErrorView(errorMessage: errorMessage)
                    Spacer()
                }
                authView
            }
        }
    }
    
    var authView: some View {
        VStack(spacing: Constants.Design.LayoutConstants.defaultSpacing.rawValue) {
            Text("Login")
                .font(.largeTitle)
                .fontWeight(.heavy)
            HStack {
                Image(systemName: Assets.userImage.rawValue)
                TextField("Username", text: $viewModel.credentials.username)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: Constants.Design.LayoutConstants.cornerRadius.rawValue)
                    .foregroundStyle(.clear)
                    .overlay {
                        RoundedRectangle(cornerRadius: Constants.Design.LayoutConstants.cornerRadius.rawValue)
                            .stroke(.primary, lineWidth: 2)
                    }
            )
            
            HStack {
                Image(systemName: Assets.passwordImage.rawValue)
                if viewModel.isPasswordVisible {
                    TextField("Password",
                              text: $viewModel.credentials.password)
                    
                } else {
                    SecureField("Password",
                                text: $viewModel.credentials.password)
                    
                }
                Image(systemName: viewModel.passwordThumbImageName)
                    .onTapGesture {
                        withAnimation {
                            viewModel.isPasswordVisible.toggle()
                        } 
                    }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: Constants.Design.LayoutConstants.cornerRadius.rawValue)
                    .foregroundStyle(.clear)
                    .overlay {
                        RoundedRectangle(cornerRadius: Constants.Design.LayoutConstants.cornerRadius.rawValue)
                            .stroke(.primary, lineWidth: 2)
                    }
            )
            
            Button("Sign In") {
                Task {
                    do {
                        try await viewModel.checkValidation()
                        await authentication.checkSession()
                    } catch {
                        viewModel.authState = .login
                        throw error
                    }
                }
            }
            .disabled(viewModel.isLoggingDisabled)
            .opacity(viewModel.isLoggingDisabled ? 0.5 : 1.0)
        }
        .textInputAutocapitalization(.never)
        .disableAutocorrection(true)
        .padding()
        .fontWeight(.semibold)
    }
}


