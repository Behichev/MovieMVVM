//
//  LoginViewModel.swift
//  NetworkApp
//
//  Created by Ivan Behichev on 21.04.2025.
//

import Foundation

@MainActor
final class LoginViewModel: ObservableObject {
    
    @Published var credentials = Credentials()
    @Published var authState: AuthViewState = .login
    @Published var isPasswordVisible = false
    
    var isInvalidCredentials = false
    
    var isLoggingDisabled: Bool {
        credentials.username.isEmpty || credentials.password.isEmpty
    }
    
    var passwordThumbImageName: String {
        isPasswordVisible ? "eye.slash.fill" : "eye.fill"
    }
    
    private let repository: TMDBRepositoryProtocol
    
    init(repository: TMDBRepositoryProtocol) {
        self.repository = repository
    }
    
    enum AuthViewState {
        case login
        case loading
    }
    
    func signIn() async throws {
        authState = .loading
        do {
            try await repository.requestToken()
            try await repository.userAuthorization(with: credentials)
            try await repository.createSession()
        } catch {
            isInvalidCredentials = true
            authState = .login
        }
    }
}
