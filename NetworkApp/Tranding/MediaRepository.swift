//
//  MediaRepository.swift
//  NetworkApp
//
//  Created by Ivan Behichev on 08.05.2025.
//

import Foundation

protocol MediaRepository {
    func fetchMedia() async throws -> [MediaItem]
    func fetchFavorites() async throws 
    func addToFavorite(_ media: MediaItem) async throws
    func deleteFromFavorites(_ media: MediaItem) async throws
    func loadImage(_ path: String) async throws -> Data
}
