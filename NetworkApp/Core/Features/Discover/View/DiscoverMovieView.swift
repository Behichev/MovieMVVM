//
//  DiscoverMovieView.swift
//  NetworkApp
//
//  Created by Ivan Behichev on 16.05.2025.
//

import SwiftUI

struct DiscoverMovieView: View {
    
    @State var viewModel: DiscoverMovieViewModel
    let onMediaTapped: (Int) -> Void
    
    var body: some View {
        ScrollView {
            switch viewModel.viewState {
            case .loading:
                ProgressView()
            case .success:
                if viewModel.movies.isEmpty {
                    emptyView
                } else {
                    mainContent
                        .padding()
                }
            }
                
        }
        .navigationTitle("Movies")
        .task {
            if !viewModel.isHasLoaded {
                try? await viewModel.loadMovies()
            }
        }
        
    }
}

//MARK: UI Components

private extension DiscoverMovieView {
    
    var emptyView: some View {
        VStack(spacing: 16) {
            Image(systemName: "movieclapper")
                .font(.largeTitle)
                .foregroundStyle(.primary)
            Text("Movies is empty")
        }
    }
    
    
    var mainContent: some View {
        LazyVStack {
            ForEach(viewModel.movies, id: \.id) { movie in
                
                    MediaPreviewCell(media: movie) { path in
                        try? await viewModel.setImage(path)
                    } onFavoritesTapped: {
                        print("Add to favorites")
                    }
                    .onTapGesture {
                        onMediaTapped(movie.id)
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

