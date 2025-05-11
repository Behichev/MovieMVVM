//
//  AuthenticationState.swift
//  NetworkApp
//
//  Created by Ivan Behichev on 26.04.2025.
//

import Foundation

@MainActor
final class AuthenticationState: ObservableObject {
    
    @Published var isAuthenticated = true
    
    private let userRepository: UserRepository
    private let sessionRepository: SessionRepository
    private let keychainService: SecureStorable
    
    private var validationTask: Task<Void, Never>? = nil
    
    private var sessionID: String
    private var userID: String
    
    init(userRepository: UserRepository, sessionRepository: SessionRepository, keychainService: SecureStorable) {
        self.userRepository = userRepository
        self.sessionRepository = sessionRepository
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
            let _ = try await userRepository.fetchUser(with: Constants.APIKeys.key)
            isAuthenticated = true
        } catch {
            isAuthenticated = false
        }
    }
    
    func logout() async {
        do {
            try await sessionRepository.deleteSession(Constants.APIKeys.token, sessionID)
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
