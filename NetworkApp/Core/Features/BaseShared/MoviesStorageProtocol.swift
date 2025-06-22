//
//  MoviesStorage.swift
//  NetworkApp
//
//  Created by Ivan Behichev on 14.05.2025.
//

import Foundation

protocol MoviesStorageProtocol {
    
    var trendingMovies: [MediaItem] { get set }
    var favoritesMovies: [MediaItem] { get set }
    var moviesList: [MediaItem] { get set }
    var moviesCache: [Movie] {get set } 
    func favoritesToggle(_ item: MediaItem)
    func addToFavorites(_ item: MediaItem)
    func removeFromFavorites (_ item: MediaItem)
}
