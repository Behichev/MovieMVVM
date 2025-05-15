//
//  MoviesStorage.swift
//  NetworkApp
//
//  Created by Ivan Behichev on 14.05.2025.
//

import Foundation

final class MoviesStorage: MoviesStorageProtocol {
    
    private var movies: [MediaItem] = []
    private var favoriteMovies: [MediaItem] = []
    
    func getTrendingMovies() -> [MediaItem] {
        return movies
    }
    
    func getFavoritesMovies() -> [MediaItem] {
        return favoriteMovies
    }
    
    func saveTrendingMovies(_ movies: [MediaItem]) {
        self.movies = movies
    }
    
    func saveFavoriteMovies(_ movies: [MediaItem]) {
        self.favoriteMovies = movies
    }
    
    func addToFavorites(_ item: MediaItem) {
        if let index = movies.firstIndex(where: { $0.id == item.id }) {
            movies[index].isInFavorites = true
        }
        
        if !favoriteMovies.contains(where: {$0.id == item.id}) {
            favoriteMovies.append(item)
        }
    }
    
    func removeFromFavorites(_ item: MediaItem) {
        if let index = movies.firstIndex(where: { $0.id == item.id }) {
            movies[index].isInFavorites = false
        }
        
        if let index = favoriteMovies.firstIndex(where: { $0.id == item.id }) {
            favoriteMovies.remove(at: index)
        }
    }
}
