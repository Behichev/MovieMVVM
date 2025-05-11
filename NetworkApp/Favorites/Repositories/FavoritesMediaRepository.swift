//
//  FavoritesMediaRepository.swift
//  NetworkApp
//
//  Created by Ivan Behichev on 10.05.2025.
//

import Foundation

protocol FavoritesMediaRepository {
    func getData() async throws -> [MediaItem]
    func removeFromFavorites(_ item: MediaItem) async throws
    func loadImage(_ string: String) async throws -> Data
}
