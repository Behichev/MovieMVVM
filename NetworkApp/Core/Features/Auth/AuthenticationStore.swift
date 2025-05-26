//
//  AuthenticationState.swift
//  NetworkApp
//
//  Created by Ivan Behichev on 26.04.2025.
//

import Foundation

@MainActor
final class AuthenticationStore: ObservableObject {
    
    @Published var isAuthenticated = false
    
    private let repository: TMDBRepositoryProtocol
    private let keychainService: SecureStorable
    
    private var validationTask: Task<Void, Never>? = nil
    
    private var sessionID: String
    private var userID: String
    
    init(repository: TMDBRepositoryProtocol, keychainService: SecureStorable) {
        self.repository = repository
        self.keychainService = keychainService
        
        sessionID = keychainService.get(forKey: Constants.KeychainKeys.session.rawValue, as: String.self) ?? ""
        userID = String(keychainService.get(forKey: Constants.KeychainKeys.userID.rawValue, as: Int.self) ?? 0)
        
        validationTask = Task {
            await checkSession()
        }
    }
    
    func checkSession() async {
        do {
            updateKeys()
            let _ = try await repository.fetchUser(with: Constants.APIKeys.key)
            isAuthenticated = true
        } catch {
            isAuthenticated = false
        }
    }
    
    func logout() async {
        do {
            try await repository.deleteSession(Constants.APIKeys.token, sessionID)
            keychainService.delete(forKey: Constants.KeychainKeys.userID.rawValue)
            keychainService.delete(forKey: Constants.KeychainKeys.session.rawValue)
            isAuthenticated = false
        } catch {
            isAuthenticated = true
        }
    }
    
    private func updateKeys() {
        sessionID = keychainService.get(forKey: Constants.KeychainKeys.session.rawValue, as: String.self) ?? ""
        userID = String(keychainService.get(forKey: Constants.KeychainKeys.userID.rawValue, as: Int.self) ?? 0)
    }
}
