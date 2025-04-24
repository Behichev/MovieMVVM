//
//  NetworkLayer.swift
//  NetworkApp
//
//  Created by Ivan Behichev on 10.04.2025.
//

import Foundation

enum Constants: String {
    case baseURL = "https://api.themoviedb.org"
}

enum TMDBPath {
    enum Trending: String {
        case moviesToday = "/3/trending/movie/day"
        case moviesWeek = "/3/trending/movie/week"
        case tvToday = "/3/trending/tv/day"
        case tvWeek = "/3/trending/tv/week"
    }
    
    enum Auth: String {
        case newToken = "/3/authentication/token/new"
        case validateWithLogin = "/3/authentication/token/validate_with_login"
        case newSession = "/3/authentication/session/new"
    }
    
    enum Movie: String {
        case popular = "/3/movie/popular"
        case details = "/3/movie/{ movie_id }"
    }
    
    enum User: String {
        case user = "/3/account"
    }
    
//    enum User: String {
//        case user(let apiKey, sessionID) = "?api_key=\(apiKey)&session_id=\(sessionID)""
//    }
}

enum HTTPMethods: String {
    case get = "GET"
    case post = "POST"
    case patch = "PATCH"
    case put = "PUT"
    case delete = "DELETE"
}

protocol Endpoint {
    var path: String { get }
    var headers: [String : String]? {get}
    var body: Parameters? { get }
    var httpMethod: HTTPMethods { get }
    var queryItems: [URLQueryItem]? { get }
}

typealias Parameters = [String: Any]

//URLQueryItem(name: "language", value: "en-US")

protocol NetworkService {
    func performRequest<T: Decodable>(from endpoint: Endpoint) async throws -> T
}

struct NetworkLayer: NetworkService {
    
    private let session: URLSession
    private let decoder: DataDecoder
    
    init(session: URLSession = .shared, decoder: DataDecoder = JSONDataDecoder()) {
        self.session = session
        self.decoder = decoder
    }
    
    func performRequest<T>(from endpoint: Endpoint) async throws -> T where T : Decodable {
        guard let basePath = URL(string: "https://api.themoviedb.org") else { throw URLError(.badURL) }
        
        var components = URLComponents()
        components.scheme = basePath.scheme
        components.host = basePath.host
        components.path = endpoint.path
        components.queryItems = endpoint.queryItems
        
        guard let url = components.url else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.httpMethod.rawValue
        request.timeoutInterval = 60
        request.allHTTPHeaderFields = endpoint.headers
        
        var body = endpoint.body
        
        if let body {
            request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        }
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              200..<300 ~= httpResponse.statusCode else {
            throw URLError(.badServerResponse)
        }
        
            return try decoder.decode(T.self, from: data)
    }
}
