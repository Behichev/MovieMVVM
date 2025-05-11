//
//  APIEndpoints.swift
//  NetworkApp
//
//  Created by Ivan Behichev on 26.04.2025.
//

import Foundation

enum TimeWindow: String {
    case week
    case day
}

enum MediaType: String {
    case movie
    case tv
}

enum MediaEndpoint: Endpoint {
    
    case trending(mediaItem: MediaType, timeWindow: TimeWindow.RawValue)
    case favoriteMovies(accountId: String)
    case addToFavorites(accountId: String, item: MediaItem)
    case removeFromFavorites(accountId: String, item: MediaItem)
    
    var path: String {
        switch self {
        case .trending(let mediaItem, timeWindow: let timeWindow):
            return "/3/trending/\(mediaItem.rawValue)/\(timeWindow)"
        case .favoriteMovies(let accountId):
            return "/3/account/\(accountId)/favorite/movies"
        case .addToFavorites(let accountId, _), .removeFromFavorites(let accountId, _):
            return "/3/account/\(accountId)/favorite"
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .trending(_,_), .favoriteMovies(_), .addToFavorites(_, _), .removeFromFavorites(_, _):
            [
                "accept": "application/json",
                "content-type": "application/json",
                "Authorization": "Bearer \(Constants.APIKeys.token)"
            ]
        }
    }
    
    var body: Parameters? {
        switch self {
        case .trending(_, _), .favoriteMovies(_):
            return nil
        case .addToFavorites(_, let mediaItem):
            return [
                "media_type": mediaItem.mediaType?.rawValue,
                "media_id": mediaItem.id,
                "favorite": true
            ]
        case .removeFromFavorites(_, let mediaItem):
            return [
                "media_type": mediaItem.mediaType?.rawValue,
                "media_id": mediaItem.id,
                "favorite": false
            ]
        }
    }
    
    var httpMethod: HTTPMethods {
        switch self {
        case .trending(_, _), .favoriteMovies(_):
                .get
        case .addToFavorites(_, _), .removeFromFavorites(_, _):
                .post
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .trending(_, _):
            nil
        case .favoriteMovies(_):
            [
              URLQueryItem(name: "language", value: "en-US"),
              URLQueryItem(name: "page", value: "1"),
              URLQueryItem(name: "sort_by", value: "created_at.asc"),
            ]
        case .addToFavorites(_, _), .removeFromFavorites(_, _):
            nil
        }
    }
}

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
