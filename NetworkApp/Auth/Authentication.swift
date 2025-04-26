//
//  Authentication.swift
//  NetworkApp
//
//  Created by Ivan Behichev on 26.04.2025.
//

import Foundation

@MainActor
class Authentication: ObservableObject {
    
    @Published var isAuthenticated = false
    
    let authService: TMDBAuthService
    let loginVM: LoginViewModel
    private var sessionID = KeychainManager.get(forKey: "currentSessionID", as: String.self)
    
    
    init(authService: TMDBAuthService) {
        self.authService = authService
        self.loginVM = LoginViewModel(authService: authService)
        
        Task {
            await checkSession()
        }
    }
    
    func checkSession() async {
        do {
            try await authService.fetchUser(with: Constants.APIKeys.key.rawValue, sessionID: sessionID ?? "")
            isAuthenticated = true
        } catch {
            isAuthenticated = false
        }
    }
    
    func logout() async {
        do {
            try await authService.deleteSession(Constants.APIKeys.token.rawValue, sessionID ?? "")
            KeychainManager.delete(forKey: "currentSessionID")
            isAuthenticated = false
        } catch {
            isAuthenticated = true
        }
    }
}
