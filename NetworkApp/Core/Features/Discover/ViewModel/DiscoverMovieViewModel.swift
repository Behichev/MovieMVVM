//
//  DiscoverMovieViewModel.swift
//  NetworkApp
//
//  Created by Ivan Behichev on 16.05.2025.
//

import SwiftUI

@MainActor
final class DiscoverMovieViewModel: ObservableObject {
    
    @Published var movies: [MediaItem] = []
    @Published var viewState: DiscoverViewState = .loading
    
    var isHasLoaded = false
    var isNextPageLoading = false
    
    private var currentPage = 1
    
    let repository: TMDBRepositoryProtocol
    
    init(repository: TMDBRepositoryProtocol) {
        self.repository = repository
    }
    
    deinit {
        print("DEBUG: Discover deinit")
    }
    
    enum DiscoverViewState {
        case loading
        case success
    }
    
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
}
