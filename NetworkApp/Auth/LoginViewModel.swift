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
    
    private let repository: TMDBAuthRepository
    
    var isLoggingDisabled: Bool {
        credentials.username.isEmpty || credentials.password.isEmpty
    }
    
    var passwordThumbImageName: String {
        isPasswordVisible ? "eye.slash.fill" : "eye.fill"
    }
    
    init(repository: TMDBAuthRepository) {
        self.repository = repository
    }
    
    enum AuthViewState {
        case login
        case loading
        case error(errorMessage: String)
    }
    
    func signIn() async throws {
        authState = .loading
        do {
            try await repository.login(credentials)
        } catch let authError as NetworkError {
            authState = .error(errorMessage: authError.localizedDescription)
            await resetErrorAfterDelay()
        } catch {
            authState = .error(errorMessage: String(describing: error))
            await resetErrorAfterDelay()
            throw error
        }
    }
    
    private func resetErrorAfterDelay() async {
        try? await Task.sleep(nanoseconds: 4_000_000_000)
        authState = .login
    }
}
