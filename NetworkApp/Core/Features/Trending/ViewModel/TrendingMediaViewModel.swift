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
    
    private let repository: TrendingMediaRepository
    
    init(repository: TrendingMediaRepository) {
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
    
    func favoritesToggle(_ item: MediaItem) async throws {
        do {
            if item.isInFavorites ?? false {
               let result = try await repository.deleteFromFavorites(item)
                updateFavorite(result.0, result.1)
            } else {
                let result = try await repository.addToFavorite(item)
                updateFavorite(result.0, result.1)
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
            throw error
        }
    }
    
    private func updateFavorite(_ id: Int, _ bool: Bool) {
        if let index = media.firstIndex(where: {$0.id == id }) {
            media[index].isInFavorites = bool
        }
    }
}
