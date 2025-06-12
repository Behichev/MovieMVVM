//
//  DiscoverMovieViewModel.swift
//  NetworkApp
//
//  Created by Ivan Behichev on 16.05.2025.
//

import SwiftUI

@Observable
final class DiscoverMovieViewModel {
    
    var movies: [MediaItem] = []
    var viewState: DiscoverViewState = .loading
    
    @ObservationIgnored var isHasLoaded = false
    @ObservationIgnored var isNextPageLoading = false
    
    @ObservationIgnored private var currentPage = 1
    
    @ObservationIgnored let repository: TMDBRepositoryProtocol
    @ObservationIgnored let mediaType: MediaType = .movie
    
    init(repository: TMDBRepositoryProtocol) {
        self.repository = repository
    }
    
    enum DiscoverViewState {
        case loading
        case success
    }
    
    @MainActor
    func loadMovies() async throws {
        if movies.isEmpty {
            viewState = .loading
        }
        do {
            movies = try await repository.fetchMovieList(page: currentPage)
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
            
            let existingIDs = Set(movies.map { $0.id })
            let uniqueMovies = newMovies.filter { !existingIDs.contains($0.id) }
            
            movies += uniqueMovies
        } catch {
            throw error
        }
    }
    
    @MainActor
    func favoritesToggle(_ item: MediaItem) async throws {
        do {
            updateFavorite(item)
            try await repository.favoritesToggle(item, mediaType: mediaType)
        } catch {
            updateFavorite(item)
            throw error
        }
    }
    
    func hasReachedEnd(of item: MediaItem) -> Bool {
        movies.last?.id == item.id
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
        if let index = movies.firstIndex(where: { $0.id == item.id }) {
            movies[index].isInFavorites = item.isInFavorites ?? false ? false : true
        }
    }
}
