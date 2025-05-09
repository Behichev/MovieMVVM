//
//  TrendingMediaRepository.swift
//  NetworkApp
//
//  Created by Ivan Behichev on 08.05.2025.
//

import Foundation

actor TrendingMediaRepository: MediaRepository {
    
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
        userID = keychainService.get(forKey: Constants.KeychainKeys.userID.rawValue, as: String.self) ?? ""
    }
    
    func fetchMedia() async throws -> [MediaItem] {
        do {
            if mediaList.isEmpty {
                let mediaResult: MediaResult = try await networkService.performRequest(from: MediaEndpoint.trending(mediaItem: .movie, timeWindow: TimeWindow.day.rawValue))
                mediaList = mediaResult.results
                return mediaList
            } else {
                return mediaList
            }
        } catch {
            throw error
        }
    }
    
    func fetchFavorites() async throws {
        print("User ID: \(userID)")
        let mediaResult: MediaResult = try await networkService.performRequest(from: MediaEndpoint.favoriteMovies(accountId: userID))
        favoriteMediaList = mediaResult.results
        updateFavoriteList()
    }
    
    func addToFavorite(_ media: MediaItem) async throws {
        do {
            try await networkService.performPostRequest(from: MediaEndpoint.addToFavorites(accountId: userID, item: media))
            if let index = favoriteMediaList.firstIndex(where: { $0.id == media.id }) {
                favoriteMediaList[index].isInFavorites = true
                updateFavoriteList()
            }
        } catch {
            throw error
        }
    }
    
    func deleteFromFavorites(_ media: MediaItem) async throws {
        do {
            try await networkService.performPostRequest(from: MediaEndpoint.removeFromFavorites(accountId: userID, item: media))
            if let index = favoriteMediaList.firstIndex(where: { $0.id == media.id }) {
                favoriteMediaList[index].isInFavorites = false
                updateFavoriteList()
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
            throw error
        }
    }
    
    private func updateFavoriteList() {
        for (index, item) in mediaList.enumerated() {
            if let _ = favoriteMediaList.first(where: { $0.id == item.id }) {
                mediaList[index].isInFavorites = true
            } else {
                mediaList[index].isInFavorites = false
            }
        }
    }
}
