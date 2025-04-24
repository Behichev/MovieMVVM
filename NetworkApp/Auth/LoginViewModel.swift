//
//  LoginViewModel.swift
//  NetworkApp
//
//  Created by Ivan Behichev on 21.04.2025.
//

import Foundation

class LoginViewModel: ObservableObject {
    
    @Published var username = ""
    @Published var password = ""
    private let authService: TMDBAuthServiceProtocol
    
    init(authService: TMDBAuthServiceProtocol) {
        self.authService = authService
    }
    
    func signIn() {
        Task {
            do {
                try await authService.requestToken()
                try await authService.userAuthorization(with: username, password)
                try await authService.createSession()
            } catch {
                print(error.localizedDescription)
                throw error
            }
        }
    }
}
