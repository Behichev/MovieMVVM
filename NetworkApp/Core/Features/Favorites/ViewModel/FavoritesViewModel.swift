//
//  FavoritesViewModel.swift
//  NetworkApp
//
//  Created by Ivan Behichev on 03.05.2025.
//

import SwiftUI

@Observable
final class FavoritesViewModel {
    
    var favoritesMedia: [MediaItem] = []
    var viewState: TrendingViewState = .loading
    
    @ObservationIgnored var isLoaded = false
    @ObservationIgnored let repository: TMDBRepositoryProtocol
    
    init(repository: TMDBRepositoryProtocol) {
        self.repository = repository
    }
    
    enum TrendingViewState {
        case loading
        case success
    }
    
    @MainActor
    func fetchFavorites() async throws {
        if favoritesMedia.isEmpty {
            viewState = .loading
        }
        do {
            favoritesMedia = try await repository.fetchFavoritesMovies()
            viewState = .success
            isLoaded = true
        } catch {
            throw error
        }
    }
    
    @MainActor
    func removeFromFavorites(_ item: MediaItem) async throws {
        do {
            if let index = favoritesMedia.firstIndex(where: {$0.id == item.id }) {
                withAnimation {
                    favoritesMedia.remove(at: index)
                }
            }
            try? await repository.deleteMovieFromFavorites(item)
            viewState = .success
        }
    }
    
    func setImage(_ path: String) async throws -> UIImage? {
        do {
            let data = try await repository.loadImage(path)
            let image = UIImage(data: data)
            return image
        } catch {
            throw error
        }
    }
}
