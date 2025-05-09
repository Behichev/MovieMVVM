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
    let keychainService: SecureStorable
    
    private var validationTask: Task<Void, Never>? = nil
    
    private var sessionID: String
    private var userID: String
    
    init(authService: TMDBAuthService, keychainService: SecureStorable) {
        self.authService = authService
        self.keychainService = keychainService
        
        sessionID = keychainService.get(forKey: Constants.KeychainKeys.session.rawValue, as: String.self) ?? ""
        userID = keychainService.get(forKey: Constants.KeychainKeys.userID.rawValue, as: String.self) ?? ""
        print(sessionID)
        validationTask = Task {
            await checkSession()
        }
    }
    
    func checkSession() async {
        do {
            try await authService.fetchUser(with: Constants.APIKeys.key, sessionID: sessionID)
            isAuthenticated = true
        } catch {
            isAuthenticated = false
        }
    }
    
    func logout() async {
        do {
            try await authService.deleteSession(Constants.APIKeys.token, sessionID)
            keychainService.delete(forKey: Constants.KeychainKeys.session.rawValue)
            keychainService.delete(forKey: Constants.KeychainKeys.userID.rawValue)
            isAuthenticated = false
        } catch {
            isAuthenticated = true
        }
    }
}
