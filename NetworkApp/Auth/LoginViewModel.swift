//
//  LoginViewModel.swift
//  NetworkApp
//
//  Created by Ivan Behichev on 21.04.2025.
//

import Foundation

@MainActor
class LoginViewModel: ObservableObject {
    
    @Published var credentials = Credentials()
    @Published var errorMessage: String? = nil
    @Published var authState: AuthState = .login
    @Published var isPasswordVisible = false
    
    private let authService: TMDBAuthService
    
    var isLoggingDisabled: Bool {
        credentials.username.isEmpty || credentials.password.isEmpty
    }
    
    init(authService: TMDBAuthService) {
        self.authService = authService
    }
    
    enum AuthState {
        case login
        case loading
    }
    
    func checkValidation() async throws {
            authState = .loading
            errorMessage = nil
            do {
                try await authService.requestToken()
                try await authService.userAuthorization(with: credentials)
                try await authService.createSession()
            } catch let authError as NetworkError {
                authState = .login
                errorMessage = authError.localizedDescription
            } catch {
                authState = .login
                errorMessage = String(describing: error)
                throw error
            }
    }
    
}
