//
//  ValidationService.swift
//  NetworkApp
//
//  Created by Ivan Behichev on 21.04.2025.
//

import Foundation

final class ValidationService {
    
    var session: URLSession
    var decoder: DataDecoder
    
    init(session: URLSession = .shared, decoder: DataDecoder = JSONDataDecoder()) {
        self.session = session
        self.decoder = decoder
    }
    
    func validateSession(_ apiKey: String, _ sessionID: String) async throws -> Bool {
        let stringURL = "https://api.themoviedb.org/3/account?api_key=\(apiKey)&session_id=\(sessionID)"
        guard let url = URL(string: stringURL) else { throw URLError(.badURL) }
        let request = URLRequest(url: url)
        let (data, _) = try await session.data(for: request)
        
        do {
            let _ = try decoder.decode(Account.self, from: data)
            return true
        } catch {
            return false
        }
    }
    
}

