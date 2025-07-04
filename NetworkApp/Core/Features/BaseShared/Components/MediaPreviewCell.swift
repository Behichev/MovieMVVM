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
        HStack(alignment: .top) {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 128)
                    .cornerRadius(Constants.Design.LayoutConstants.cornerRadius.rawValue)
            } else {
                skeletonImageView
            }
            VStack(spacing: 32) {
                VStack(spacing: 8) {
                    HStack {
                        Text(media.name ?? media.title ?? "No title")
                            .font(.headline.bold())
                        
                        Spacer()
                        
                        Button {
                            onFavoritesTapped()
                        } label: {
                            Image(systemName: media.isInFavorites ?? false ? "star.fill" : "star")
                        }
                        .buttonStyle(.plain)
                    }
                    
                    HStack() {
                        Image(systemName: "calendar")
                            .font(.caption2)
                        Text(DateFormatterManager.shared.formattedDate(from: media.releaseDate ?? media.firstAirDate ?? "") ?? "")
                            .font(.footnote)
                        Spacer()
                    }
                }
                Text(media.overview)
                    .multilineTextAlignment(.leading)
                    .lineLimit(3)
            }
        }
        .background(.clear)
        
        
        
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

#Preview(traits: .sizeThatFitsLayout) {
    MediaPreviewCell(media: MockHelper.mockMediaItem) { _ in
        await MockHelper.setImage("")
    } onFavoritesTapped: {
        print("favorite")
    }
    .padding()
}
