//
//  DiscoverMovieView.swift
//  NetworkApp
//
//  Created by Ivan Behichev on 16.05.2025.
//

import SwiftUI

struct DiscoverMovieView: View {
    
    @StateObject var viewModel: DiscoverMovieViewModel
    @EnvironmentObject var coordinator: Coordinator
    
    var body: some View {
        ScrollView {
            switch viewModel.viewState {
            case .loading:
                ProgressView()
            case .success:
                if viewModel.movies.isEmpty {
                    VStack {
                        Image(systemName: "movieclapper")
                            .font(.largeTitle)
                            .foregroundStyle(.primary)
                        Text("Movies is empty")
                    }
                } else {
                    mainContent
                        .padding()
                }
            }
            
        }
        .task {
            if !viewModel.isHasLoaded {
                try? await viewModel.loadMovies()
            }
        }
        
    }
}

//MARK: UI Components

private extension DiscoverMovieView {
    var mainContent: some View {
        LazyVStack {
            ForEach(viewModel.movies, id: \.id) { movie in
                
                    MediaPreviewCell(media: movie) { path in
                        try? await viewModel.setImage(path)
                    } onFavoritesTapped: {
                        print("Add to favorites")
                    }
                    .onTapGesture {
                        coordinator.push(.movie(movieID: movie.id))
                    }
            
                if viewModel.hasReachedEnd(of: movie) {
                    ProgressView()
                        .tint(.accentColor)
                        .task{
                            if !viewModel.isNextPageLoading {
                                try? await viewModel.loadNextMovies()
                            }
                        }
                }
            }
        }
    }
}

#Preview {
    let repository = TMDBRepository(networkService: NetworkService(), imageService: TMDBImageLoader(), keychainService: KeychainService(), dataSource: MoviesStorage(), errorManager: ErrorManager())
    let viewModel = DiscoverMovieViewModel(repository: repository)
    DiscoverMovieView(viewModel: viewModel)
}
