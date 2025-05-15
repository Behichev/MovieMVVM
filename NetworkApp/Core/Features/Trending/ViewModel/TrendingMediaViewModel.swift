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
    
    private let repository: TMDBRepositoryProtocol
    
    init(repository: TMDBRepositoryProtocol) {
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
            media = try await repository.fetchTrendingMedia()
            viewState = .success
        } catch {
            viewState = .error(message: error.localizedDescription)
        }
    }
    
    func favoritesToggle(_ item: MediaItem) async throws {
        do {
            updateFavorite(item)
            try await repository.favoritesToggle(item)
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
    
    private func updateFavorite(_ item: MediaItem) {
        if let index = media.firstIndex(where: { $0.id == item.id }) {
            media[index].isInFavorites = item.isInFavorites ?? false ? false : true
        }
    }
}
