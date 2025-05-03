//
//  TrendingMediaView.swift
//  NetworkApp
//
//  Created by Ivan Behichev on 10.04.2025.
//

import SwiftUI

struct TrendingMediaView: View {
    
    @StateObject private var viewModel: TrendingMediaViewModel
    
    init(networkService: NetworkService, imageService: ImageLoaderService) {
        _viewModel = StateObject(wrappedValue: TrendingMediaViewModel(networkService: networkService, imageLoader: imageService))
    }
    
    var body: some View {
        NavigationView {
            Group {
                if viewModel.isLoading {
                    ProgressView("Loading...")
                } else if let error = viewModel.errorMessage {
                    Text("Error: \(error)")
                        .foregroundColor(.blue)
                } else {
                    mediaListView
                }
            }
            .navigationTitle("Trending")
        }
        .task {
            await viewModel.fetchMovies()
        }
    }
    
    var mediaListView: some View {
        ScrollView {
            LazyVStack {
                ForEach(viewModel.media, id: \.id) { media in
                    MediaPreviewCell(media: media) { url in
                        await viewModel.loadImage(from: url)
                    } onFavoritesTapped: {
                        Task {
                           try await viewModel.handleFavorite(media.isInFavorites ?? false, media: media)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    TrendingMediaView(networkService: NetworkLayer(), imageService: TMDBImageLoader())
}
