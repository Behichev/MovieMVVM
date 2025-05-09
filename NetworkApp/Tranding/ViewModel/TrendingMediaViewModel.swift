//
//  TrendingMediaViewModel.swift
//  NetworkApp
//
//  Created by Ivan Behichev on 15.04.2025.
//

import SwiftUI

@MainActor
final class TrendingMediaViewModel: ObservableObject {
    
    @Published var media: [MediaItem] = []
    @Published var viewState: TrendingMediaViewState = .loading
    
    private let repository: MediaRepository
    
    init(repository: MediaRepository) {
        self.repository = repository
    }
    
    enum TrendingMediaViewState {
        case loading
        case success
        case error(message: String)
    }
    
    func loadMedia() async throws {
        viewState = .loading
        do {
            media = try await repository.fetchMedia()
            viewState = .success
        } catch {
            viewState = .error(message: error.localizedDescription)
        }
    }
    
    func favoritesToggle(_ media: MediaItem) async throws {
        do {
            if media.isInFavorites ?? false {
                try await repository.deleteFromFavorites(media)
            } else {
                try await repository.addToFavorite(media)
            }
        } catch {
            viewState = .error(message: error.localizedDescription)
            throw error
        }
    }
    
    func setImage(_ path: String) async throws -> UIImage? {
        do {
            let data = try await repository.loadImage(path)
            let image = UIImage(data: data)
            return image
        } catch {
            viewState = .error(message: error.localizedDescription)
            throw error
        }
    }
    
    func refreshFavoriteStatuses() async {
        do {
            try await repository.fetchFavorites()
        } catch {
            viewState = .error(message: error.localizedDescription)
        }
    }
}
