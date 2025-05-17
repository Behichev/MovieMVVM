//
//  DiscoverMovieView.swift
//  NetworkApp
//
//  Created by Ivan Behichev on 16.05.2025.
//

import SwiftUI

struct DiscoverMovieView: View {
    
    @StateObject private var viewModel: DiscoverMovieViewModel
    private let repository: TMDBRepositoryProtocol
    
    init(repository: TMDBRepositoryProtocol) {
        self.repository = repository
        _viewModel = StateObject(wrappedValue: DiscoverMovieViewModel(repository: repository))
    }
    
    var body: some View {
        switch viewModel.viewState {
        case .loading:
            mainContent
                .overlay {
                    LoaderView()
                }
        case .success:
            mainContent
        }
    }
    
}

//MARK: UI Components

private extension DiscoverMovieView {
    var mainContent: some View {
        NavigationView {
            ScrollView {
                LazyVStack {
                    ForEach(viewModel.movies) { movie in
                        NavigationLink(destination: MovieDetailsView(repository: repository, movieID: movie.id)) {
                            MediaPreviewCell(media: movie) { path in
                               try? await viewModel.setImage(path)
                            } onFavoritesTapped: {
                                //
                            }
                            .task {
                                if viewModel.hasReachedEnd(of: movie) {
                                   try? await viewModel.loadNextMovies()
                                }
                            }
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .padding(.horizontal)
            .navigationTitle("Movies")
        }
        .task {
            try? await viewModel.loadMovies()
        }
    }
}

#Preview {
    DiscoverMovieView(repository: TMDBRepository(networkService: NetworkLayer(), imageService: TMDBImageLoader(), keychainService: KeychainService(), dataSource: MoviesStorage()))
}
