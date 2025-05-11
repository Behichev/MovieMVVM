//
//  TrendingMediaRepositoryImpl.swift
//  NetworkApp
//
//  Created by Ivan Behichev on 08.05.2025.
//

import Foundation

actor TrendingMediaRepositoryImpl: TrendingMediaRepository {
    
    private var mediaList: [MediaItem] = []
    private var favoriteMediaList: [MediaItem] = []
    private let userID: String
    private let networkService: NetworkService
    private let keychainService: SecureStorable
    private let imageService: ImageLoaderService
    
    init(networkService: NetworkService, keychainService: SecureStorable, imageLoaderService: ImageLoaderService) {
        self.networkService = networkService
        self.keychainService = keychainService
        self.imageService = imageLoaderService
        userID = String(keychainService.get(forKey: Constants.KeychainKeys.userID.rawValue, as: Int.self) ?? 0)
    }
    
    func fetchMedia() async throws -> [MediaItem] {
        do {
            let mediaResult: MediaResult = try await networkService.performRequest(from: MediaEndpoint.trending(mediaItem: .movie, timeWindow: TimeWindow.day.rawValue))
            mediaList = mediaResult.results
            try await fetchFavorites()
            syncWithFavorites()
            return mediaList
        } catch {
            throw error
        }
    }
    
    func fetchFavorites() async throws {
        let mediaResult: MediaResult = try await networkService.performRequest(from: MediaEndpoint.favoriteMovies(accountId: userID))
        favoriteMediaList = mediaResult.results
    }
    
    func addToFavorite(_ item: MediaItem) async throws -> (Int, Bool) {
        do {
            try await networkService.performPostRequest(from: MediaEndpoint.addToFavorites(accountId: userID, item: item))
            if let index = mediaList.firstIndex(where: { $0.id == item.id }) {
                mediaList[index].isInFavorites = true
                return (id: mediaList[index].id, value: true)
            }
            return (0, false)
        } catch {
            throw error
        }
    }
    
    func deleteFromFavorites(_ item: MediaItem) async throws -> (Int, Bool) {
        do {
            try await networkService.performPostRequest(from: MediaEndpoint.removeFromFavorites(accountId: userID, item: item))
            if let index = mediaList.firstIndex(where: { $0.id == item.id }) {
                mediaList[index].isInFavorites = false
                return (id: mediaList[index].id, value: false)
            }
            return (0, false)
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
            throw error
        }
    }
    
    private func syncWithFavorites() {
        for (index, item) in mediaList.enumerated() {
            if let _ = favoriteMediaList.first(where: { $0.id == item.id }) {
                mediaList[index].isInFavorites = true
            } else {
                mediaList[index].isInFavorites = false
            }
        }
    }
}
