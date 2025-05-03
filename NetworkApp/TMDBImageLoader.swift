//
//  TMDBImageLoader.swift
//  NetworkApp
//
//  Created by Ivan Behichev on 17.04.2025.
//

import Foundation

class TMDBImageLoader: ImageLoaderService {
    
    func prepareImagePath(from string: String) throws -> URL {
        let stringURL = "https://image.tmdb.org/t/p/w200\(string)"
        guard let url = URL(string: stringURL) else { throw URLError(.badURL) }
        return url
    }
    
    func loadImageData(from url: URL) async throws -> Data {
        let (data, _) = try await URLSession.shared.data(from: url)
        return data
    }
}
