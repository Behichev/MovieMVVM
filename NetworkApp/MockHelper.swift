//
//  MockHelper.swift
//  NetworkApp
//
//  Created by Ivan Behichev on 13.06.2025.
//

import UIKit

struct MockHelper {
    static let mockMediaItem: MediaItem = MediaItem(id: 238, name: nil, originalName: nil, title: "The Godfather", originalTitle: "The Godfather", overview: "Spanning the years 1945 to 1955, a chronicle of the fictional Italian-American Corleone crime family. When organized crime family patriarch, Vito Corleone barely survives an attempt on his life, his youngest son, Michael steps in to take care of the would-be killers, launching a campaign of bloody revenge.", posterPath: "/3bhkrj58Vtu7enYsRolD1fZdja1.jpg", backdropPath: "/tmU7GeKVybMWFButWEGl2M4GeiP.jpg", adult: false, originalLanguage: "en", genreIds: [18,80], popularity: 55.5205, voteAverage: 8.686, voteCount: 21522, originCountry: nil, firstAirDate: nil, releaseDate: "1972-03-14", video: false)
    
    static func setImage(_ poster: String) async -> UIImage? {
        return UIImage(named: "mockPoster")
    }
}
