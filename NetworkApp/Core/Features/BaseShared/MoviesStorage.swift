//
//  MoviesStorage.swift
//  NetworkApp
//
//  Created by Ivan Behichev on 14.05.2025.
//

import Foundation

@Observable
final class MoviesStorage: MoviesStorageProtocol {
    
    var trendingMovies: [MediaItem] = []
    var favoritesMovies: [MediaItem] = []
    var moviesList: [MediaItem] = []
    var moviesCache: [Movie] = []
    
    func favoritesToggle(_ item: MediaItem) {
        if let favoriteItem = item.isInFavorites {
            if favoriteItem {
                removeFromFavorites(item)
                print("remove")
            } else {
                addToFavorites(item)
                print("add")
            }
        } else {
            addToFavorites(item)
            print("add from nil")
        }
    }
    
    func addToFavorites(_ item: MediaItem) {
        if let index = moviesList.firstIndex(where: { $0.id == item.id }) {
            moviesList[index].isInFavorites = true
        }
        
        if let index = trendingMovies.firstIndex(where: { $0.id == item.id }) {
            trendingMovies[index].isInFavorites = true
        }
        
        if !favoritesMovies.contains(where: {$0.id == item.id}) {
            var newItem = item
            newItem.isInFavorites = true
            favoritesMovies.append(newItem)
        }
    }
    
    func removeFromFavorites(_ item: MediaItem) {
        if let index = trendingMovies.firstIndex(where: { $0.id == item.id }) {
            trendingMovies[index].isInFavorites = false
        }
        
        if let index = moviesList.firstIndex(where: { $0.id == item.id }) {
            moviesList[index].isInFavorites = false
        }
        
        if let index = favoritesMovies.firstIndex(where: { $0.id == item.id }) {
            favoritesMovies.remove(at: index)
        }
    }
}
