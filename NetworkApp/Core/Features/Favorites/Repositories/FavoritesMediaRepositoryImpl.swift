//
//  FavoritesMoviesRepository.swift
//  NetworkApp
//
//  Created by Ivan Behichev on 10.05.2025.
//

import Foundation

actor FavoritesMediaRepositoryImpl: FavoritesMediaRepository {
    
    private var favoriteMediaList: [MediaItem] = []
    private let userID: String
    private let networkService: NetworkService
    private let keychainService: SecureStorable
    private let imageService: ImageLoaderService
    
    init(networkService: NetworkService, keychainService: SecureStorable, imageService: ImageLoaderService) {
        self.networkService = networkService
        self.keychainService = keychainService
        self.imageService = imageService
        
        userID = String(keychainService.get(forKey: Constants.KeychainKeys.userID.rawValue, as: Int.self) ?? 0)
    }
    
    func getData() async throws -> [MediaItem] {
        do {
            let mediaResult: MediaResult = try await networkService.performRequest(from: MediaEndpoint.favoriteMovies(accountId: userID))
            favoriteMediaList = mediaResult.results
            
            for (index, _) in favoriteMediaList.enumerated() {
                favoriteMediaList[index].isInFavorites = true
            }
            
            return favoriteMediaList
        } catch {
            throw error
        }
    }
    
    func removeFromFavorites(_ item: MediaItem) async throws {
        do {
            var removeItem = item
            removeItem.mediaType = .movie
            try await networkService.performPostRequest(from: MediaEndpoint.removeFromFavorites(accountId: userID, item: removeItem))
            if let index = favoriteMediaList.firstIndex(where: { $0.id == item.id }) {
                favoriteMediaList.remove(at: index)
            }
        } catch {
            throw error
        }
    }
    
    func loadImage(_ string: String) async throws -> Data {
        do {
            let url = try imageService.prepareImagePath(from: string)
            let data = try await imageService.loadImageData(from: url)
            return data
        } catch {
            print("Favorites Image is canceled")
            throw error
        }
    }
}
