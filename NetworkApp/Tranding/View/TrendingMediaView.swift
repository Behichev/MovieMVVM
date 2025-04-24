//
//  TrendingMediaView.swift
//  NetworkApp
//
//  Created by Ivan Behichev on 10.04.2025.
//

import SwiftUI

struct TrendingMediaView: View {
    
    @StateObject private var viewModel = MoviesViewModel(networkService: NetworkLayer(), imageLoader: ImageLoader())
    
    var body: some View {
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
        .padding()
        .task {
            await viewModel.fetchMovies()
        }
    }
    
    var mediaListView: some View {
        ScrollView {
            LazyVStack {
                ForEach(viewModel.mediaList, id: \.id) { media in
                    MediaContentCell(viewModel: viewModel, media: media)
                }
            }
        }
    }
}

#Preview {
    TrendingMediaView()
}
