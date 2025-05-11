//
//  SessionRepository.swift
//  NetworkApp
//
//  Created by Ivan Behichev on 11.05.2025.
//

import Foundation

protocol SessionRepository {
    func deleteSession(_ apiKey: String, _ sessionID: String) async throws
}

actor SessionRepositoryImpl: SessionRepository {
    
    private let networkService: NetworkService
    private var authEndpoint: AuthEndpoint?
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func deleteSession(_ apiKey: String, _ sessionID: String) async throws {
        authEndpoint = .deleteUser(apiKey: apiKey, sessionID: sessionID)
        guard let authEndpoint else { return }
        do {
            try await networkService.performPostRequest(from: authEndpoint)
        } catch {
            throw error
        }
    }
}


