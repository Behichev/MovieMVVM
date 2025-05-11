//
//  UserRepository.swift
//  NetworkApp
//
//  Created by Ivan Behichev on 11.05.2025.
//

import Foundation

protocol UserRepository {
    func fetchUser(with apiKey: String) async throws -> User
}

actor TMDBUserRepositoryImpl: UserRepository {
    
    private let networkService: NetworkService
    private let keychainService: SecureStorable
    private var authEndpoint: AuthEndpoint?
    
    init(networkService: NetworkService, keychainService: SecureStorable) {
        self.networkService = networkService
        self.keychainService = keychainService
    }
    
    func fetchUser(with apiKey: String) async throws -> User {
        let sessionID = keychainService.get(forKey: Constants.KeychainKeys.session.rawValue, as: String.self) ?? ""
        authEndpoint = .validation(apiKey: apiKey, sessionID: sessionID)
        guard let authEndpoint else { throw URLError(.badURL) }
        do {
            let user: User = try await networkService.performRequest(from: authEndpoint)
            keychainService.save(user.id, forKey: Constants.KeychainKeys.userID.rawValue)
            return user
        } catch {
            throw error
        }
    }
}
