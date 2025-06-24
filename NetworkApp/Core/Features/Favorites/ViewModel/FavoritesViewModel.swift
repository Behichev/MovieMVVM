//
//  FavoritesViewModel.swift
//  NetworkApp
//
//  Created by Ivan Behichev on 03.05.2025.
//

import SwiftUI

@Observable
final class FavoritesViewModel {
    
    var viewState: TrendingViewState = .loading
    var mediaStorage: MoviesStorage
    
    @ObservationIgnored var isLoaded = false
    @ObservationIgnored let repository: TMDBRepositoryProtocol
    
    init(repository: TMDBRepositoryProtocol, mediaStorage: MoviesStorage) {
        self.repository = repository
        self.mediaStorage = mediaStorage
    }
    
    enum TrendingViewState {
        case loading
        case success
    }
    
    @MainActor
    func fetchFavorites() async throws {
        viewState = .loading
        
        do {
            if mediaStorage.favoritesMovies.isEmpty {
                mediaStorage.favoritesMovies = try await repository.fetchFavoritesMovies()
                viewState = .success
                isLoaded = true
            } else {
                let favoritesMovies = try await repository.fetchFavoritesMovies()
                if mediaStorage.favoritesMovies != favoritesMovies {
                    mediaStorage.favoritesMovies = favoritesMovies
                    viewState = .success
                    isLoaded = true
                } else {
                    viewState = .success
                    isLoaded = true
                }
            }
        } catch {
            throw error
        }
    }
    
    @MainActor
    func removeFromFavorites(_ item: MediaItem) async throws {
        do {
            withAnimation {
                mediaStorage.removeFromFavorites(item)
            }
            try? await repository.deleteMediaFromFavorites(item)
        }
    }
    
    func setImage(_ path: String) async throws -> UIImage? {
        do {
            let data = try await repository.loadImage(path, size: 200)
            let image = UIImage(data: data)
            return image
        } catch {
            throw error
        }
    }
}
