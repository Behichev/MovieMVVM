//
//  MovieDetailsView.swift
//  NetworkApp
//
//  Created by Ivan Behichev on 17.05.2025.
//

import SwiftUI

struct MovieDetailsView: View {
    
    @StateObject private var viewModel: MovieDetailsViewModel
    
    init(repository: TMDBRepositoryProtocol, movieID: Int) {
        _viewModel = StateObject(wrappedValue: MovieDetailsViewModel(repository: repository, movieID: movieID))
    }
    
    
    var body: some View {
        Text(viewModel.movie?.title ?? "No Title")
            .task {
               try? await viewModel.getMovieDetails()
            }
    }
}

#Preview {
    let repo = TMDBRepository(networkService: NetworkLayer(),imageService: TMDBImageLoader(), keychainService: KeychainService(),dataSource: MoviesStorage())
    MovieDetailsView(repository: repo, movieID: 12)
}
