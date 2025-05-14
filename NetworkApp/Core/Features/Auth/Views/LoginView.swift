//
//  LoginView.swift
//  NetworkApp
//
//  Created by Ivan Behichev on 21.04.2025.
//

import SwiftUI

struct LoginView: View {
    
    @StateObject var viewModel: LoginViewModel
    @EnvironmentObject var authentication: AuthenticationStore
    
    init(repository: TMDBRepositoryProtocol) {
        _viewModel = StateObject(wrappedValue: LoginViewModel(repository: repository))
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
}

//MARK: - Components

private extension LoginView {
    
    var authView: some View {
        VStack(spacing: Constants.Design.LayoutConstants.defaultSpacing.rawValue) {
            title
            usernameTextField
            passwordTextField
            signInButton
        }
        .textInputAutocapitalization(.never)
        .disableAutocorrection(true)
        .padding()
        .fontWeight(.semibold)
    }
    
    var title: some View {
        Text("Login")
            .font(.largeTitle)
            .fontWeight(.heavy)
    }
    
    var usernameTextField: some View {
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
    }
    
    var passwordTextField: some View {
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
    }
    
    var signInButton: some View {
        Button("Sign In") {
            Task {
                try await viewModel.signIn()
                await authentication.checkSession()
            }
        }
        .disabled(viewModel.isLoggingDisabled)
        .opacity(viewModel.isLoggingDisabled ? 0.5 : 1.0)
    }
}
