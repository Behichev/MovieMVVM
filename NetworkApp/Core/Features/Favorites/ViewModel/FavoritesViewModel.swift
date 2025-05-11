//
//  FavoritesViewModel.swift
//  NetworkApp
//
//  Created by Ivan Behichev on 03.05.2025.
//

import SwiftUI

@MainActor
final class FavoritesViewModel: ObservableObject {
    
    @Published var favoritesMedia: [MediaItem] = []
    @Published var viewState: TrendingViewState = .loading
    
    let repository: FavoritesMediaRepository
    
    init(repository: FavoritesMediaRepository) {
        self.repository = repository
    }
    
    enum TrendingViewState {
        case loading
        case success
        case error(errorMessage: String)
    }
    
    func fetchFavorites() async throws {
        viewState = .loading
        do {
            favoritesMedia = try await repository.getData()
            viewState = .success
        } catch {
            viewState = .error(errorMessage: error.localizedDescription)
            throw error
        }
    }
    
    func removeFromFavorites(_ item: MediaItem) async throws {
        viewState = .loading
        do {
            try await repository.removeFromFavorites(item)
            if let index = favoritesMedia.firstIndex(where: {$0.id == item.id }) {
                favoritesMedia.remove(at: index)
            }
            viewState = .success
        } catch {
            viewState = .error(errorMessage: error.localizedDescription)
            throw error
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
