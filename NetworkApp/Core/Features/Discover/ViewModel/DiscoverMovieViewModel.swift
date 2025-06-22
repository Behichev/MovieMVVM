//
//  DiscoverMovieViewModel.swift
//  NetworkApp
//
//  Created by Ivan Behichev on 16.05.2025.
//

import SwiftUI

@Observable
final class DiscoverMovieViewModel {
    
    var movieStorage: MoviesStorageProtocol
    var viewState: DiscoverViewState = .loading
    
    @ObservationIgnored var isHasLoaded = false
    @ObservationIgnored var isNextPageLoading = false
    
    @ObservationIgnored private var currentPage = 1
    
    @ObservationIgnored let repository: TMDBRepositoryProtocol
    @ObservationIgnored let mediaType: MediaType = .movie
    
    init(repository: TMDBRepositoryProtocol, movieStorage: MoviesStorageProtocol) {
        self.repository = repository
        self.movieStorage = movieStorage
    }
    
    enum DiscoverViewState {
        case loading
        case success
    }
    
    @MainActor
    func loadMovies() async throws {
        if movieStorage.moviesList.isEmpty {
            viewState = .loading
        }
        do {
            movieStorage.moviesList = try await repository.fetchMovieList(page: currentPage)
            for item in movieStorage.favoritesMovies {
                updateFavorite(item)
            }
            isHasLoaded = true
            viewState = .success
        } catch {
            isHasLoaded = false
            throw error
        }
    }
    
    @MainActor
    func loadNextMovies() async throws {
        guard !isNextPageLoading else { return }
        isNextPageLoading = true
        defer { isNextPageLoading = false }
        
        currentPage += 1
        
        do {
            let newMovies = try await repository.fetchMovieList(page: currentPage)
            
            let existingIDs = Set(movieStorage.moviesList.map { $0.id })
            let uniqueMovies = newMovies.filter { !existingIDs.contains($0.id) }
            
            movieStorage.moviesList += uniqueMovies
            for item in movieStorage.favoritesMovies {
                updateFavorite(item)
            }
        } catch {
            throw error
        }
    }
    
    @MainActor
    func favoritesToggle(_ item: MediaItem) async throws {
        do {
            movieStorage.favoritesToggle(item)
            try await repository.favoritesToggle(item, mediaType: mediaType)
        } catch {
            updateFavorite(item)
            throw error
        }
    }
    
    func hasReachedEnd(of item: MediaItem) -> Bool {
        movieStorage.moviesList.last?.id == item.id
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
        if let index = movieStorage.moviesList.firstIndex(where: { $0.id == item.id }) {
            movieStorage.moviesList[index].isInFavorites = item.isInFavorites ?? false
        }
    }
}
