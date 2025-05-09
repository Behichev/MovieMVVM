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
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private var userID: String
    
    let networkService: NetworkService
    let imageService: ImageLoaderService
    let keychainService: SecureStorable
    
    init(networkService: NetworkService, imageService: ImageLoaderService, keychainService: SecureStorable) {
        self.networkService = networkService
        self.imageService = imageService
        self.keychainService = keychainService
        userID = String(describing: keychainService.get(forKey: Constants.KeychainKeys.userID.rawValue, as: Int.self))
        
    }
    
    func fetchFavorites() async {
        isLoading = true
        errorMessage = nil
        do {
            let result: MediaResult = try await networkService.performRequest(from: MediaEndpoint.favoriteMovies(accountId: userID))
            favoritesMedia = result.results
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
    
    func deleteFromFavorites(_ item: MediaItem) async throws {
        do {
            var removeItem = item
            removeItem.mediaType = .movie
            try await networkService.performPostRequest(from: MediaEndpoint.removeFromFavorites(accountId: userID, item: removeItem))
            favoritesMedia.removeAll(where: {$0.id == item.id})
        } catch {
            print(error)
            throw error
        }
    }
    
    func loadImage(from path: String) async -> UIImage? {
        do {
            let url = try imageService.prepareImagePath(from: path)
            let data = try await imageService.loadImageData(from: url)
            return UIImage(data: data)
        } catch {
            print("Failed to load image: \(error)")
            return nil
        }
    }
}
