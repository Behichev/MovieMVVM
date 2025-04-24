//
//  ImageLoader.swift
//  NetworkApp
//
//  Created by Ivan Behichev on 17.04.2025.
//

import Foundation

class ImageLoader: ImageLoaderService {
    
    func loadImageData(from url: URL) async throws -> Data {
        let (data, _) = try await URLSession.shared.data(from: url)
        return data
    }
}
