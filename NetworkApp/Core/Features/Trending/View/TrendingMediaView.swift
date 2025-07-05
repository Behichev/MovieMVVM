//
//  TrendingMediaView.swift
//  NetworkApp
//
//  Created by Ivan Behichev on 10.04.2025.
//

import SwiftUI

struct TrendingMediaView: View {
    
    @State var viewModel: TrendingMediaViewModel
    let onMediaTapped: (Int) -> Void
    
    var body: some View {
        ScrollView {
            switch viewModel.viewState {
            case .loading:
                ProgressView()
                    .tint(.accentColor)
            case .success:
                if viewModel.mediaStorage.trendingMovies.isEmpty {
                    
                    emptyView
                } else {
                    mainContent
                        .padding()
                }
            }
        }
        .navigationTitle("Trending")
        .refreshable {
            Task {
                try? await viewModel.loadTrendingMedia()
            }
        }
        .task {
            if !viewModel.isLoaded {
                try? await viewModel.loadTrendingMedia()
            }
        }
    }
}

//MARK: - Components

private extension TrendingMediaView {
    var mainContent: some View {
        LazyVStack {
            cells
        }
    }
    
    var cells: some View {
        ForEach(viewModel.mediaStorage.trendingMovies, id: \.id) { media in
            MediaPreviewCell(media: media) { url in
                try? await viewModel.setImage(url)
            } onFavoritesTapped: {
                Task {
                    try? await viewModel.favoritesToggle(media)
                }
            }
            .onTapGesture {
                onMediaTapped(media.id)
            }
        }
    }
    
    var emptyView: some View {
        VStack(alignment: .center, spacing: 16) {
            Rectangle()
                .foregroundStyle(.clear)
                .frame(height: 248)
            
            Image(systemName: "movieclapper")
                .font(.system(size: 92))
                
            Text("Trending media")
                .font(.largeTitle)
                .fontWeight(.bold)
                .fontDesign(.rounded)
        }
        
    }
}

#Preview {
    let repository = MockRepository()
    let movieStorage = MockMovieStorage()
    let vm = TrendingMediaViewModel(repository: repository, mediaStorage: movieStorage)
    TrendingMediaView(viewModel: vm, onMediaTapped: { _ in print("sdsd") })
}
