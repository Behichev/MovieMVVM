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
    
    @ObservationIgnored private let repository: TMDBRepositoryProtocol
    @ObservationIgnored private let movieID: Int
    
    init(repository: TMDBRepositoryProtocol, movieID: Int) {
        self.repository = repository
        self.movieID = movieID
    }
    
    @MainActor
    func getMovieDetails() async throws {
        do {
            movie = try await repository.fetchMovie(movieID)
        } catch {
            throw error
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
}
