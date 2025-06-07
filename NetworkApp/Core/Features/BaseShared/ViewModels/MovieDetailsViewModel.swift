//
//  MovieDetailsViewModel.swift
//  NetworkApp
//
//  Created by Ivan Behichev on 17.05.2025.
//

import SwiftUI

@MainActor
final class MovieDetailsViewModel: ObservableObject {
    
    @Published var movie: Movie?
    
    private let repository: TMDBRepositoryProtocol
    private let movieID: Int
    
    init(repository: TMDBRepositoryProtocol, movieID: Int) {
        self.repository = repository
        self.movieID = movieID
    }
    
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
