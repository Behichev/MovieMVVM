//
//  MoviesStorage.swift
//  NetworkApp
//
//  Created by Ivan Behichev on 14.05.2025.
//

import Foundation

protocol MoviesStorageProtocol {
    func getTrendingMovies() -> [MediaItem]
    func getFavoritesMovies() -> [MediaItem]
    func saveTrendingMovies(_ movies: [MediaItem])
    func saveFavoriteMovies(_ movies: [MediaItem])
    func addToFavorites(_ item: MediaItem)
    func removeFromFavorites (_ item: MediaItem)
}
