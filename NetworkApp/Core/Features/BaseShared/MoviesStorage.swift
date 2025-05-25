//
//  MoviesStorage.swift
//  NetworkApp
//
//  Created by Ivan Behichev on 14.05.2025.
//

import Foundation

final class MoviesStorage: MoviesStorageProtocol {
    
    private var trendingMovies: [MediaItem] = []
    private var favoriteMovies: [MediaItem] = []
    private var moviesList: [MediaItem] = []
    private var moviesCache: [Movie] = []
    
    func getTrendingMovies() -> [MediaItem] {
        return trendingMovies
    }
    
    func getFavoritesMovies() -> [MediaItem] {
        return favoriteMovies
    }
    
    func getMoviesList() -> [MediaItem] {
        return moviesList
    }
    
    func getMovieDetail(_ id: Int) -> Movie? {
        if let index = moviesCache.firstIndex(where: {$0.id == id }) {
            return moviesCache[index]
        } else {
            return nil
        }
    }
    
    
    func saveMoviesList(_ movies: [MediaItem]) {
        moviesList = movies
    }
    
    func saveTrendingMovies(_ movies: [MediaItem]) {
        trendingMovies = movies
    }
    
    func saveFavoriteMovies(_ movies: [MediaItem]) {
        favoriteMovies = movies
    }
    
    func saveMovie(_ movie: Movie) {
        if !moviesCache.contains(where: { $0.id == movie.id }) {
            moviesCache.append(movie)
        }
    }
    
    func addToFavorites(_ item: MediaItem) {
        if let index = trendingMovies.firstIndex(where: { $0.id == item.id }) {
            trendingMovies[index].isInFavorites = true
        }
        
        if !favoriteMovies.contains(where: {$0.id == item.id}) {
            favoriteMovies.append(item)
        }
    }
    
    func removeFromFavorites(_ item: MediaItem) {
        if let index = trendingMovies.firstIndex(where: { $0.id == item.id }) {
            trendingMovies[index].isInFavorites = false
        }
        
        if let index = favoriteMovies.firstIndex(where: { $0.id == item.id }) {
            favoriteMovies.remove(at: index)
        }
    }
}
