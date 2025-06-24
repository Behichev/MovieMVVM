//
//  TMDBImageLoader.swift
//  NetworkApp
//
//  Created by Ivan Behichev on 09.05.2025.
//

import Foundation

final class TMDBImageLoader: ImageLoaderService {
    
    private let cache = NSCache<NSURL, NSData>()
    
    func prepareImagePath(from string: String, size: Int = 200) throws -> URL {
        let stringURL = "https://image.tmdb.org/t/p/w\(size)\(string)"
        guard let url = URL(string: stringURL) else {
            throw URLError(.badURL)
        }
        return url
    }
    
    func loadImageData(from url: URL) async throws -> Data {
        
        if let cachedData = cache.object(forKey: url as NSURL) {
            return cachedData as Data
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        cache.setObject(data as NSData, forKey: url as NSURL)

        return data
    }
}
