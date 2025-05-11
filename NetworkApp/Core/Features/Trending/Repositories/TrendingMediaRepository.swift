//
//  TrendingMediaRepository.swift
//  NetworkApp
//
//  Created by Ivan Behichev on 08.05.2025.
//

import Foundation

protocol TrendingMediaRepository {
    func fetchMedia() async throws -> [MediaItem]
    func fetchFavorites() async throws 
    func addToFavorite(_ item: MediaItem) async throws -> (Int, Bool)
    func deleteFromFavorites(_ item: MediaItem) async throws -> (Int, Bool)
    func loadImage(_ path: String) async throws -> Data
}
