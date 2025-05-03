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
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private var favoriteMoviesResult: MediaResult?
    private var trendingMediaResult: MediaResult?
    
    private let networkService: NetworkService
    private let imageLoader: ImageLoaderService
    
    private var favoriteMedia: [MediaItem] = []
    private var userID = KeychainManager.get(forKey: Constants.KeychainKeys.userID.rawValue, as: Int.self)
    
    init(networkService: NetworkService, imageLoader: ImageLoaderService) {
        self.networkService = networkService
        self.imageLoader = imageLoader
    }
    
    func fetchMovies() async {
        isLoading = true
        errorMessage = nil
        do {
            trendingMediaResult = try await networkService.performRequest(from: MediaEndpoint.trending(mediaItem: .movie, timeWindow: TimeWindow.week.rawValue))
            guard let trendingMediaResult else { return }
            media = trendingMediaResult.results
            try await fetchFavoriteMedia()
            
            updateFavoriteList()
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
    
    func handleFavorite(_ isFavorite: Bool, media: MediaItem) async throws {
        if isFavorite {
            try await removeFromFavorites(media)
        } else {
            try await addToFavorites(media)
        }
        updateFavoriteList()
    }
    
   private func addToFavorites(_ item: MediaItem) async throws {
        do {
            try await networkService.performPostRequest(from: MediaEndpoint.addToFavorites(accountId: "\(userID)", item: item))
            if let index = favoriteMedia.firstIndex(where: {$0.id == item.id }) {
                favoriteMedia[index].isInFavorites = true
            } else {
                var newItem = item
                newItem.isInFavorites = true
                favoriteMedia.append(newItem)
            }
        } catch {
            throw error
        }
    }
    
   private func removeFromFavorites(_ item: MediaItem) async throws {
        do {
            try await networkService.performPostRequest(from: MediaEndpoint.removeFromFavorites(accountId: "\(userID)", item: item))
            
            if let index = favoriteMedia.firstIndex(where: { $0.id == item.id }) {
                favoriteMedia[index].isInFavorites = false
                favoriteMedia.remove(at: index)
            }
        } catch {
            throw error
        }
    }
    
    private func fetchFavoriteMedia() async throws {
        do {
            favoriteMoviesResult = try await networkService.performRequest(from: MediaEndpoint.favoriteMovies(accountId: "\(userID)"))
            guard let favoriteMoviesResult else { return }
            favoriteMedia = favoriteMoviesResult.results
            for (index, _) in favoriteMedia.enumerated() {
                favoriteMedia[index].isInFavorites = true
            }
        } catch {
            throw error
        }
    }
    
    private func updateFavoriteList() {
        for (index, item) in media.enumerated() {
            if let _ = favoriteMedia.first(where: { $0.id == item.id }) {
                media[index].isInFavorites = true
            } else {
                media[index].isInFavorites = false
            }
        }
    }
    
    func loadImage(from path: String) async -> UIImage? {
        do {
            let url = try imageLoader.prepareImagePath(from: path)
            let data = try await imageLoader.loadImageData(from: url)
            return UIImage(data: data)
        } catch {
            print("Failed to load image: \(error)")
            return nil
        }
    }
}
