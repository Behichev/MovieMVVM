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
    func getMoviesList() -> [MediaItem]
    func getMovieDetail(_ id: Int) -> Movie?
    func saveTrendingMovies(_ movies: [MediaItem])
    func saveFavoriteMovies(_ movies: [MediaItem])
    func saveMovie(_ movie: Movie)
    func addToFavorites(_ item: MediaItem)
    func removeFromFavorites (_ item: MediaItem)
}
