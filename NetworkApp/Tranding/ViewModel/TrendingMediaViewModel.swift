//
//  TrendingMediaViewModel.swift
//  NetworkApp
//
//  Created by Ivan Behichev on 15.04.2025.
//

import SwiftUI

@MainActor
final class TrendingMediaViewModel: ObservableObject {
    
    @Published var mediaList: [MediaItem] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private var mediaResult: MediaList?
    private let networkService: NetworkService
    private let imageLoader: ImageLoaderService
    
    init(networkService: NetworkService, imageLoader: ImageLoaderService) {
        self.networkService = networkService
        self.imageLoader = imageLoader
    }
    
    func fetchMovies() async  {
        isLoading = true
        errorMessage = nil
        do {
            mediaResult = try await networkService.performRequest(from: MediaEndpoint.trending(mediaType: MediaType.movie.rawValue, timeWindow: TimeWindow.week.rawValue))
            guard let mediaResult = mediaResult?.results else { return }
            mediaList = mediaResult
        } catch {
            errorMessage = error.localizedDescription
        }
        mediaList = mediaResult?.results ?? []
        isLoading = false
    }
    
    func addToFavorites(_ type: MediaType.RawValue, id: Int) async throws {
        do {
            try await networkService.performPostRequest(from: MediaEndpoint.addToFavorites(accountId: "12270475", mediaType: type, mediaId: id))
        } catch {
            throw error
        }
    }
    
    func loadImage(from path: String) async -> UIImage? {
        guard let url = prepareImagePath(path) else { return nil }
        do {
            let data = try await imageLoader.loadImageData(from: url)
            return UIImage(data: data)
        } catch {
            print("Failed to load image: \(error)")
            return nil
        }
    }
    
    func prepareImagePath(_ imagePath: String?) -> URL? {
        guard let imagePath else { return nil }
        let urlString = "https://image.tmdb.org/t/p/w200\(imagePath)"
        return URL(string: urlString)
    }
}

