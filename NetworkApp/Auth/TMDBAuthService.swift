//
//  TMDBAuthService.swift
//  NetworkApp
//
//  Created by Ivan Behichev on 21.04.2025.
//

import Foundation

protocol TMDBAuthServiceProtocol {
    func requestToken() async throws
    func userAuthorization(with username: String, _ password: String) async throws
    func createSession() async throws
}

final class TMDBAuthService: TMDBAuthServiceProtocol {
    
    enum AuthEndpoint: Endpoint {
        case newToken(apiKey: String)
        case validateWithLogin(apiKey: String, requestToken: String, username: String, password: String)
        case newSession(apiKey: String, sessionID: String)
        
        var path: String {
            switch self {
            case .newToken:
                return TMDBPath.Auth.newToken.rawValue
            case .validateWithLogin:
                return TMDBPath.Auth.validateWithLogin.rawValue
            case .newSession:
                return TMDBPath.Auth.newSession.rawValue
            }
        }
        
        var headers: [String : String]? {
            switch self {
            case .newToken(let apiKey),
                    .validateWithLogin(let apiKey, _, _, _),
                    .newSession(let apiKey, _):
                return ["Content-Type": "application/json",
                        "Authorization": apiKey]
            }
        }
        
        var body: Parameters? {
            switch self {
            case .validateWithLogin(_, let requestToken, let username, let password):
                return [
                    "username": username,
                    "password": password,
                    "request_token": requestToken
                ]
            case .newSession(_, let sessionID):
                return [
                    "request_token": sessionID
                ]
            case .newToken:
                return nil
            }
        }
        
        var httpMethod: HTTPMethods {
            switch self {
            case .newToken: return .get
            case .validateWithLogin: return .post
            case .newSession: return .post
            }
        }
        
        var queryItems: [URLQueryItem]? {
            switch self {
            case .newToken(_),
                    .validateWithLogin(_, _, _, _),
                    .newSession(_, _):
                return nil
            }
        }
    }
    
    let apiKey = "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI0ZjhhZmIzNTg4MWE4NzNhZDBhYmM1YzMyZGNmYmNiMSIsIm5iZiI6MTY1MDM5MDA1Mi42NDk5OTk5LCJzdWIiOiI2MjVlZjQyNGE1MDQ2ZTAwYTQ3MWYzMGQiLCJzY29wZXMiOlsiYXBpX3JlYWQiXSwidmVyc2lvbiI6MX0.MLHk3L0kQmmiCZi03FcfALHc_Sc_YXcyLjI3siu3nhQ"
    private let decoder: DataDecoder
    private let networkService: NetworkService
    private var authEndpoint: AuthEndpoint?
    private(set) var token: TMDBToken?
    
    init(decoder: DataDecoder = JSONDataDecoder(), networkService: NetworkService = NetworkLayer()) {
        self.decoder = decoder
        self.networkService = networkService
    }
    
    func requestToken() async throws {
        do {
            authEndpoint = .newToken(apiKey: apiKey)
            guard let authEndpoint else { return }
            token = try await networkService.performRequest(from: authEndpoint)
        } catch {
            throw error
        }
    }
    
    func userAuthorization(with username: String, _ password: String) async throws {
        do {
            authEndpoint = .validateWithLogin(apiKey: apiKey, requestToken: token?.requestToken ?? "", username: username, password: password)
            guard let authEndpoint else { return }
            let _: String = try await networkService.performRequest(from: authEndpoint)
        } catch {
            throw error
        }
    }
    
    func createSession() async throws {
        authEndpoint = .newSession(apiKey: apiKey, sessionID: token?.requestToken ?? "")
        guard let authEndpoint else { return }
        do {
            let _: String = try await networkService.performRequest(from: authEndpoint)
        } catch {
            throw error
        }
    }
}
