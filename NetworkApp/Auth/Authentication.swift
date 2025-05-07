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
    
    private var validationTask: Task<Void, Never>? = nil
    
    private var sessionID = KeychainManager.get(forKey: Constants.KeychainKeys.session.rawValue, as: String.self)
    private var userID = KeychainManager.get(forKey: Constants.KeychainKeys.userID.rawValue, as: String.self)
    
    init(authService: TMDBAuthService) {
        self.authService = authService
        self.loginVM = LoginViewModel(authService: authService)
        
        validationTask = Task {
            await checkSession()
        }
    }
    
    func checkSession() async {
        do {
            try await authService.fetchUser(with: Constants.APIKeys.key, sessionID: sessionID ?? "")
            isAuthenticated = true
        } catch {
            isAuthenticated = false
        }
    }
    
    func logout() async {
        do {
            try await authService.deleteSession(Constants.APIKeys.token, sessionID ?? "")
            KeychainManager.delete(forKey: Constants.KeychainKeys.session.rawValue)
            KeychainManager.delete(forKey: Constants.KeychainKeys.userID.rawValue)
            isAuthenticated = false
        } catch {
            isAuthenticated = true
        }
    }
}
