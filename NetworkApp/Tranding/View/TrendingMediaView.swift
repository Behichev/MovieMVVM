//
//  TrendingMediaView.swift
//  NetworkApp
//
//  Created by Ivan Behichev on 10.04.2025.
//

import SwiftUI

struct TrendingMediaView: View {
    
    @StateObject private var viewModel: TrendingMediaViewModel
    
    init(repository: MediaRepository) {
        _viewModel = StateObject(wrappedValue: TrendingMediaViewModel(repository: repository))
    }
    
    var body: some View {
        NavigationView {
            Group {
                switch viewModel.viewState {
                case .loading:
                    mediaListView
                        .overlay {
                            LoaderView()
                        }
                case .success:
                    mediaListView
                case .error(let message):
                    ZStack {
                        mediaListView
                        VStack {
                            ErrorView(errorMessage: message)
                                Spacer()
                        }
                    }
                }
            }
            .padding()
            .navigationTitle("Trending")
            .task {
                if viewModel.media.isEmpty {
                    try? await viewModel.loadMedia()
                }
                
                await viewModel.refreshFavoriteStatuses()
            }
        }
    }
}

private extension TrendingMediaView {
    var mediaListView: some View {
        ScrollView {
            LazyVStack {
                ForEach(viewModel.media, id: \.id) { media in
                    MediaPreviewCell(media: media) { url in
                        try? await viewModel.setImage(url)
                    } onFavoritesTapped: {
                        Task {
                           try? await viewModel.favoritesToggle(media)
                        }
                    }
                }
            }
        }
        
    }
}
