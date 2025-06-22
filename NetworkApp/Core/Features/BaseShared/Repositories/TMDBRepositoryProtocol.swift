//
//  TMDBRepositoryProtocol.swift
//  NetworkApp
//
//  Created by Ivan Behichev on 14.05.2025.
//

import Foundation

protocol TMDBRepositoryProtocol {
    func requestToken() async throws
    func userAuthorization(with credentials: Credentials) async throws
    func createSession() async throws
    func deleteSession(_ apiKey: String, _ sessionID: String) async throws
    func fetchUser(with apiKey: String) async throws -> User
    func fetchTrendingMedia() async throws -> [MediaItem]
    func fetchFavoritesMovies() async throws -> [MediaItem]
    func favoritesToggle(_ item: MediaItem, mediaType: MediaType) async throws
    func addMovieToFavorite(_ item: MediaItem) async throws
    func addMovieToFavorite(_ movieID: Int) async throws
    func removeMovieFromFavorites(_ movieID: Int) async throws
    func deleteMediaFromFavorites(_ item: MediaItem) async throws
    func loadImage(_ path: String) async throws -> Data
    func fetchMovieList(page: Int) async throws -> [MediaItem]
    func fetchMovie(_ id: Int) async throws -> Movie
}
