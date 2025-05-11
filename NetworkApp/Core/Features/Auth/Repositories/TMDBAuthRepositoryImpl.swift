//
//  TMDBAuthRepository.swift
//  NetworkApp
//
//  Created by Ivan Behichev on 21.04.2025.
//

import Foundation

protocol TMDBAuthRepository {
    func requestToken() async throws
    func userAuthorization(with credentials: Credentials) async throws
    func createSession() async throws
    func login(_ credentials: Credentials) async throws
}

final class TMDBAuthRepositoryImpl: TMDBAuthRepository {
    
    private let networkService: NetworkService
    private let keychainService: SecureStorable
    
    private var authEndpoint: AuthEndpoint?
    private var token: TMDBToken?
    
    init(networkService: NetworkService = NetworkLayer(), keychainService: SecureStorable) {
        self.networkService = networkService
        self.keychainService = keychainService
    }
    
    func login(_ credentials: Credentials) async throws {
        do {
            try await requestToken()
            try await userAuthorization(with: credentials)
            try await createSession()
        } catch {
            throw error
        }
    }
    
    func requestToken() async throws {
        do {
            authEndpoint = .newToken(apiKey: Constants.APIKeys.token)
            guard let authEndpoint else { return }
            token = try await networkService.performRequest(from: authEndpoint)
        } catch {
            print("Token error")
            throw error
        }
    }
    
    func userAuthorization(with credentials: Credentials) async throws {
        authEndpoint = .validateWithLogin(apiKey: Constants.APIKeys.token, requestToken: token?.requestToken ?? "", credentials: credentials)
        guard let authEndpoint else { return }
        do {
            try await networkService.performPostRequest(from: authEndpoint)
        } catch NetworkError.invalidCredentials {
            throw NetworkError.invalidCredentials
        } catch {
            print("Auth error")
            throw error
        }
    }
    
    func createSession() async throws {
        authEndpoint = .newSession(apiKey: Constants.APIKeys.token, sessionID: token?.requestToken ?? "")
        guard let authEndpoint else { return }
        do {
            let token: SessionModel = try await networkService.performRequest(from: authEndpoint)
            keychainService.save(token.sessionId, forKey: Constants.KeychainKeys.session.rawValue)
        } catch {
            print("Session error")
            throw error
        }
    }
}
