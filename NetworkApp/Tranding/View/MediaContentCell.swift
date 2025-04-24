//
//  MediaContentCell.swift
//  NetworkApp
//
//  Created by Ivan Behichev on 18.04.2025.
//

import SwiftUI

struct MediaContentCell: View {
    
    let viewModel: MoviesViewModel
    let media: MediaItem
    @State private var image: UIImage?
    
    var body: some View {
        HStack {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .frame(width: 100)
                    .cornerRadius(12)
                    .scaledToFit()
            } else {
                ProgressView()
                    .frame(width: 100)
            }
            VStack {
                Text(media.name ?? media.title ?? "No title")
                    .font(.title.bold())
                Text(media.originalName ?? media.originalTitle ?? "No original title")
                    .font(.title2)
                    .foregroundStyle(.gray)
                Text(media.releaseDate ?? media.firstAirDate ?? "")
                
                Spacer()
            }
            .multilineTextAlignment(.leading)
            Spacer()
        }
        .task {
            if image == nil {
                image = await viewModel.loadImage(from: media.posterPath ?? "")
            }
        }
    }
}


