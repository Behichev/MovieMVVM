//
//  TrendingMediaViewModel.swift
//  NetworkApp
//
//  Created by Ivan Behichev on 15.04.2025.
//

import SwiftUI

@Observable
final class TrendingMediaViewModel {
    
    var viewState: TrendingMediaViewState = .loading
    var mediaStorage: MoviesStorageProtocol
    
    @ObservationIgnored var isLoaded = false
    @ObservationIgnored let repository: TMDBRepositoryProtocol
    
    init(repository: TMDBRepositoryProtocol, mediaStorage: MoviesStorageProtocol) {
        self.repository = repository
        self.mediaStorage = mediaStorage
    }
    
    enum TrendingMediaViewState {
        case loading
        case success
    }
    
    @MainActor
    func loadTrendingMedia() async throws {
        viewState = .loading
        do {
            if mediaStorage.trendingMovies.isEmpty {
                mediaStorage.trendingMovies = try await repository.fetchTrendingMedia()
                mediaStorage.favoritesMovies = try await repository.fetchFavoritesMovies()
                
                for item in mediaStorage.favoritesMovies {
                    updateFavorite(item)
                }
                
                isLoaded = true
                viewState = .success
            } else {
                var trendingMovies = try await repository.fetchTrendingMedia()
                let favoritesMovies = mediaStorage.favoritesMovies
                
                for item in favoritesMovies {
                    if let index = trendingMovies.firstIndex(where: { $0.id == item.id }) {
                        trendingMovies[index].isInFavorites = item.isInFavorites ?? false
                    }
                }
                
                if trendingMovies != mediaStorage.trendingMovies {
                    mediaStorage.trendingMovies = trendingMovies
                    isLoaded = true
                    viewState = .success
                } else {
                    isLoaded = true
                    viewState = .success
                }
            }
        } catch {
            viewState = .success
        }
    }
    
    @MainActor
    func favoritesToggle(_ item: MediaItem) async throws {
        let initialState = item.isInFavorites ?? false
        
        do {
            mediaStorage.favoritesToggle(item)
            try await repository.favoritesToggle(item, mediaType: .movie)
        } catch {
            if initialState {
                mediaStorage.addToFavorites(item)
            } else {
                mediaStorage.removeFromFavorites(item)
            }
            throw error
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
    
    private func updateFavorite(_ item: MediaItem) {
        if let index = mediaStorage.trendingMovies.firstIndex(where: { $0.id == item.id }) {
            mediaStorage.trendingMovies[index].isInFavorites = item.isInFavorites ?? false
        }
    }
}
