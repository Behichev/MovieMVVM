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
    
    private let authService: TMDBAuthService
    
    var isLoggingDisabled: Bool {
        credentials.username.isEmpty || credentials.password.isEmpty
    }
    
    var passwordThumbImageName: String {
        isPasswordVisible ? "eye.slash.fill" : "eye.fill"
    }
    
    init(authService: TMDBAuthService) {
        self.authService = authService
    }
    
    enum AuthViewState {
        case login
        case loading
        case error(errorMessage: String)
    }
    
    func checkValidation() async throws {
        authState = .loading
        do {
            try await authService.requestToken()
            try await authService.userAuthorization(with: credentials)
            try await authService.createSession()
        } catch let authError as NetworkError {
            authState = .error(errorMessage: authError.localizedDescription)
            await resetStateAfterDelay()
        } catch {
            authState = .error(errorMessage: String(describing: error))
            await resetStateAfterDelay()
            throw error
        }
    }
    
    private func resetStateAfterDelay() async {
        try? await Task.sleep(nanoseconds: 4_000_000_000)
        authState = .login
    }
}
