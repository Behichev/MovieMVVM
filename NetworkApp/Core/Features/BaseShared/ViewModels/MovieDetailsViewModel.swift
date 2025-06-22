//
//  MovieDetailsViewModel.swift
//  NetworkApp
//
//  Created by Ivan Behichev on 17.05.2025.
//

import SwiftUI

@Observable
final class MovieDetailsViewModel {
    
    var movie: Movie?
    var moviesStorage: MoviesStorageProtocol
    
    @ObservationIgnored private let repository: TMDBRepositoryProtocol
    @ObservationIgnored private let movieID: Int
    
    init(repository: TMDBRepositoryProtocol, moviesStorage: MoviesStorageProtocol, movieID: Int) {
        self.repository = repository
        self.movieID = movieID
        self.moviesStorage = moviesStorage
    }
    
    @MainActor
    func getMovieDetails() async throws {
        do {
            let isFavorite = checkInFavorites()
            
            if let index = moviesStorage.moviesCache.firstIndex(where: { $0.id == movieID }) {
                movie = moviesStorage.moviesCache[index]
                movie?.isInFavorite = isFavorite
                
                var updatedMovie = try await repository.fetchMovie(movieID)
                updatedMovie.isInFavorite = isFavorite
                
                if movie != updatedMovie {
                movie = updatedMovie
                }
                
                if let movie {
                    moviesStorage.moviesCache[index] = movie
                }
            } else {
                movie = try await repository.fetchMovie(movieID)
                movie?.isInFavorite = isFavorite
                if let movie {
                    moviesStorage.moviesCache.append(movie)
                }
            }
        } catch {
            throw error
        }
    }
    
    @MainActor
    func toggleFavorite() async throws {
        if movie?.isInFavorite ?? false {
            do {
                movie?.isInFavorite = false
                try await repository.removeMovieFromFavorites(movieID)
            } catch {
                movie?.isInFavorite = true
            }
        } else {
            do {
                movie?.isInFavorite = true
                try await repository.addMovieToFavorite(movieID)
            } catch {
                movie?.isInFavorite = false
            }
        }
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
    
    private func checkInFavorites() -> Bool {
        (moviesStorage.favoritesMovies.firstIndex(where: {$0.id == movieID }) != nil)
    }
}
