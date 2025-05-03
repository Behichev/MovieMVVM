//
//  TMDBAuthService.swift
//  NetworkApp
//
//  Created by Ivan Behichev on 21.04.2025.
//

import Foundation

protocol TMDBAuthService {
    func requestToken() async throws
    func userAuthorization(with credentials: Credentials) async throws
    func createSession() async throws
    func fetchUser(with apiKey: String, sessionID: String) async throws
    func deleteSession(_ apiKey: String, _ sessionID: String) async throws
}

final class AccountService: TMDBAuthService {

    enum AuthEndpoint: Endpoint {
        case newToken(apiKey: String)
        case validateWithLogin(apiKey: String, requestToken: String, credentials: Credentials)
        case newSession(apiKey: String, sessionID: String)
        case validation(apiKey: String, sessionID: String)
        case deleteUser(apiKey: String, sessionID: String)
        
        var path: String {
            switch self {
            case .newToken:
                return "/3/authentication/token/new"
            case .validateWithLogin:
                return "/3/authentication/token/validate_with_login"
            case .newSession:
                return "/3/authentication/session/new"
            case .validation:
                return "/3/account"
            case .deleteUser:
                return "/3/authentication/session"
            }
        }
        
        var headers: [String : String]? {
            switch self {
            case .newToken(let apiKey),
                    .validateWithLogin(let apiKey, _, _),
                    .newSession(let apiKey, _), .deleteUser(let apiKey, _):
                return ["Content-Type": "application/json",
                        "Authorization": "Bearer \(apiKey)"]
            case .validation(_,_):
                return ["Content-Type": "application/json"]
            }
        }
        
        var body: Parameters? {
            switch self {
            case .validateWithLogin(_, let requestToken, let credentials):
                return [
                    "username": credentials.username,
                    "password": credentials.password,
                    "request_token": requestToken
                ]
            case .newSession(_, let sessionID):
                return [
                    "request_token": sessionID
                ]
            case .newToken:
                return nil
                
            case .validation: return nil
            case .deleteUser(_, let sessionId):
                return [
                    "session_id": sessionId
                ]
            }
        }
        
        var httpMethod: HTTPMethods {
            switch self {
            case .newToken: return .get
            case .validateWithLogin: return .post
            case .newSession: return .post
            case .validation: return .get
            case .deleteUser: return .delete
            }
        }
        
        var queryItems: [URLQueryItem]? {
            switch self {
            case .newToken(_),
                    .validateWithLogin(_, _, _),
                    .newSession(_, _), .deleteUser(_, _):
                return nil
            case .validation(let apiKey, sessionID: let SessionId):
                return [
                    URLQueryItem(name: "api_key", value: apiKey),
                    URLQueryItem(name: "session_id", value: SessionId)
                    ]
            }
        }
    }
    
    private let networkService: NetworkService
    private var authEndpoint: AuthEndpoint?
    private var token: TMDBToken?
    
    init(networkService: NetworkService = NetworkLayer()) {
        self.networkService = networkService
    }
    
    func requestToken() async throws {
        do {
            authEndpoint = .newToken(apiKey: Constants.APIKeys.token.rawValue)
            guard let authEndpoint else { return }
            token = try await networkService.performRequest(from: authEndpoint)
        } catch {
            throw error
        }
    }
    
    func userAuthorization(with credentials: Credentials) async throws {
        authEndpoint = .validateWithLogin(apiKey: Constants.APIKeys.token.rawValue, requestToken: token?.requestToken ?? "", credentials: credentials)
            guard let authEndpoint else { return }
            do {
                try await networkService.performPostRequest(from: authEndpoint)
            } catch NetworkError.invalidCredentials {
                throw NetworkError.invalidCredentials
            } catch {
                throw error
            }
    }
    
    func createSession() async throws {
        authEndpoint = .newSession(apiKey: Constants.APIKeys.token.rawValue, sessionID: token?.requestToken ?? "")
        guard let authEndpoint else { return }
        do {
            let token: SessionModel = try await networkService.performRequest(from: authEndpoint)
            KeychainManager.save(token.sessionId, forKey: Constants.KeychainKeys.session.rawValue)
        } catch {
            throw error
        }
    }
    
    func fetchUser(with apiKey: String, sessionID: String) async throws {
        authEndpoint = .validation(apiKey: apiKey, sessionID: sessionID)
        guard let authEndpoint else { return }
        do {
            let acc: Account = try await networkService.performRequest(from: authEndpoint)
            KeychainManager.save(acc.id, forKey: Constants.KeychainKeys.userID.rawValue)
        } catch {
            throw error
        }
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
