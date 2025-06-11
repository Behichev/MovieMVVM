//
//  AuthenticationState.swift
//  NetworkApp
//
//  Created by Ivan Behichev on 26.04.2025.
//

import Foundation

@Observable
final class AuthenticationStore {
    
    var isAuthenticated: Bool
    
    @ObservationIgnored private let repository: TMDBRepositoryProtocol
    @ObservationIgnored private let keychainService: SecureStorable
    @ObservationIgnored private var validationTask: Task<Void, Never>? = nil
    @ObservationIgnored private var sessionID: String
    @ObservationIgnored private var userID: Int
    
    init(repository: TMDBRepositoryProtocol, keychainService: SecureStorable) {
        self.repository = repository
        self.keychainService = keychainService
        
        sessionID = keychainService.get(forKey: Constants.KeychainKeys.session.rawValue, as: String.self) ?? ""
        userID = keychainService.get(forKey: Constants.KeychainKeys.userID.rawValue, as: Int.self) ?? -1
        
        isAuthenticated = userID >= 0
    }
    
    func createSession() async {
        do {
            updateKeys()
            let _ = try await repository.fetchUser(with: Constants.APIKeys.key)
            await MainActor.run {
                isAuthenticated = true
            }
        } catch {
            await MainActor.run {
                isAuthenticated = false
            }
        }
    }
    
    func logout() async {
        do {
            try await repository.deleteSession(Constants.APIKeys.token, sessionID)
            keychainService.delete(forKey: Constants.KeychainKeys.userID.rawValue)
            keychainService.delete(forKey: Constants.KeychainKeys.session.rawValue)
            await MainActor.run {
                isAuthenticated = false
            }
        } catch {
            await MainActor.run {
                isAuthenticated = true
            }
        }
    }
    
    private func updateKeys() {
        sessionID = keychainService.get(forKey: Constants.KeychainKeys.session.rawValue, as: String.self) ?? ""
        userID = keychainService.get(forKey: Constants.KeychainKeys.userID.rawValue, as: Int.self) ?? -1
    }
}
