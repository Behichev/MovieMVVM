//
//  MediaEndpoint.swift
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
    
    case trending(mediaType: MediaType.RawValue, timeWindow: TimeWindow.RawValue)
    case favoriteMovies(accountId: String)
    case addToFavorites(accountId: String, mediaType: MediaType.RawValue, mediaId: Int)
    
    var path: String {
        switch self {
        case .trending(let mediaType, timeWindow: let timeWindow):
            return "/3/trending/\(mediaType)/\(timeWindow)"
        case .favoriteMovies(let accountId):
            return "3/account/\(accountId)/favorite/movies"
        case .addToFavorites(let accountId, _, _):
            return "3/account/\(accountId)/favorite"
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .trending(_,_), .favoriteMovies(_), .addToFavorites(_, _, _):
            [
                "accept": "application/json",
                "content-type": "application/json",
                "Authorization": "Bearer \(Constants.APIKeys.token.rawValue)"
            ]
        }
    }
    
    var body: Parameters? {
        switch self {
        case .trending(_, _), .favoriteMovies(_):
            return nil
        case .addToFavorites(_, let mediaType, let mediaId):
            return [
                "media_type": mediaType,
                "media_id": mediaId,
                "favorite": true
            ]
        }
    }
    
    var httpMethod: HTTPMethods {
        switch self {
        case .trending(_, _), .favoriteMovies(_):
                .get
        case .addToFavorites(_, _, _):
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
        case .addToFavorites(_, _, _):
            nil
        }
    }
}

