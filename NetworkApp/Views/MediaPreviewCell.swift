//
//  MediaPreviewCell.swift
//  NetworkApp
//
//  Created by Ivan Behichev on 18.04.2025.
//

import SwiftUI

struct MediaPreviewCell: View {
    
    let media: MediaItem
    let loadPoster: (String) async -> UIImage?
    let onFavoritesTapped: () -> ()
    @State private var image: UIImage?
    
    var body: some View {
        HStack {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 110)
                    .cornerRadius(20)
            } else {
                skeletonImageView
            }
            
            HStack {
                VStack {
                    Text(media.name ?? media.title ?? "No title")
                        .font(.headline.bold())
                    
                    Text(media.releaseDate ?? media.firstAirDate ?? "")
                        .font(.footnote)
                    Spacer()
                }
            }
            Spacer()
            VStack {
                Button {
                    withAnimation {
                        onFavoritesTapped()
                    }
                } label: {
                    Image(systemName: media.isInFavorites ?? false ? "star.fill" : "star")
                }
             Spacer()
            }
        }
        .task {
            if image == nil {
                image = await loadPoster(media.posterPath ?? "")
            }
        }
    }
    
    var skeletonImageView: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .foregroundColor(.gray)
                .frame(width: 110, height: 170)
            ProgressView()
                .tint(.yellow)
        }
    }
}
