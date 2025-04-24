//
//  MoviesViewModel.swift
//  NetworkApp
//
//  Created by Ivan Behichev on 15.04.2025.
//

import SwiftUI

@MainActor
final class MoviesViewModel: ObservableObject {
    
    private var mediaResult: MediaList?
    @Published var mediaList: [MediaItem] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
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
//            mediaResult = try await networkService.fetchData(from: Constants.baseURL.rawValue)
        } catch {
            errorMessage = error.localizedDescription
        }
        mediaList = mediaResult?.results ?? []
        isLoading = false
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

