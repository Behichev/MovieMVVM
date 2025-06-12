//
//  LoginViewModel.swift
//  NetworkApp
//
//  Created by Ivan Behichev on 21.04.2025.
//

import Foundation

@Observable
final class LoginViewModel {
    
    var credentials = Credentials()
    var authState: AuthViewState = .login
    var isPasswordVisible = false
    
    @ObservationIgnored var isInvalidCredentials = false
    
    @ObservationIgnored var isLoggingDisabled: Bool {
        credentials.username.isEmpty || credentials.password.isEmpty
    }
    
    @ObservationIgnored var passwordThumbImageName: String {
        isPasswordVisible ? "eye.slash.fill" : "eye.fill"
    }
    
    @ObservationIgnored private let repository: TMDBRepositoryProtocol
    
    init(repository: TMDBRepositoryProtocol) {
        self.repository = repository
    }
    
    enum AuthViewState {
        case login
        case loading
    }
    
    @MainActor
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
