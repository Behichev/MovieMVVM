//
//  FavoritesMoviesView.swift
//  NetworkApp
//
//  Created by Ivan Behichev on 24.04.2025.
//

import SwiftUI

struct FavoritesMoviesView: View {
    
    @Bindable var viewModel: FavoritesViewModel
    let onMediaTapped: (Int) -> Void
    
    var body: some View {
        ScrollView {
            switch viewModel.viewState {
            case .loading:
                ProgressView()
                    .tint(.accentColor)
            case .success:
                if viewModel.favoritesMedia.isEmpty {
                    emptyView
                } else {
                    mainContent
                }
            }
        }
        .navigationTitle("Favorites")
        .refreshable {
            Task {
                try? await viewModel.fetchFavorites()
            }
        }
        .task {
            if !viewModel.isLoaded {
                try? await viewModel.fetchFavorites()
            }
        }
    }
}

//MARK: - Components

private extension FavoritesMoviesView {
    
    var mainContent: some View {
        LazyVStack {
            cells
        }
        .padding()
    }
    
    var emptyView: some View {
        VStack(spacing: 16) {
            Image(systemName: "star.fill")
                .font(.largeTitle)
                .foregroundStyle(.primary)
            Text("Favorites is empty")
        }
    }
    
    var cells: some View {
        ForEach(viewModel.favoritesMedia, id: \.id) { media in
            createCell(with: media)
                .onTapGesture {
                    onMediaTapped(media.id)
                }
        }
    }
    
    @ViewBuilder
    private func createCell(with mediaItem: MediaItem) -> some View {
        MediaPreviewCell(media: mediaItem) { url in
            try? await viewModel.setImage(url)
        } onFavoritesTapped: {
            Task {
                try? await viewModel.removeFromFavorites(mediaItem)
            }
        }
        
    }
}
