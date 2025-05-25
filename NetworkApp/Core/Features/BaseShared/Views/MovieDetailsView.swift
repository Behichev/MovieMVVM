//
//  MovieDetailsView.swift
//  NetworkApp
//
//  Created by Ivan Behichev on 17.05.2025.
//

import SwiftUI

struct MovieDetailsView: View {
    
    @ObservedObject private var viewModel: MovieDetailsViewModel
    
    init(repository: TMDBRepositoryProtocol, movieID: Int) {
        _viewModel = ObservedObject(wrappedValue: MovieDetailsViewModel(repository: repository, movieID: movieID))
    }
    
    
    var body: some View {
        Text(viewModel.movie?.title ?? "No Title")
            .task {
               try? await viewModel.getMovieDetails()
            }
    }
}

#Preview {
    let repo = TMDBRepository(networkService: NetworkService(),imageService: TMDBImageLoader(), keychainService: KeychainService(),dataSource: MoviesStorage())
    MovieDetailsView(repository: repo, movieID: 12)
}
