//
//  NetworkAppTests.swift
//  NetworkAppTests
//
//  Created by Ivan Behichev on 10.04.2025.
//

import XCTest
@testable import NetworkApp

final class NetworkAppTests: XCTestCase {
    
    func test_favoritesToggle_withNilFavoriteStatus_shouldAddToFavorites() async throws {
        let repo = MockRepository()
        let storage = MoviesStorage()
        var item = MockHelper.mockMediaItem
        storage.trendingMovies = [item]
        let viewModel = TrendingMediaViewModel(repository: repo, mediaStorage: storage)
        
        try await viewModel.favoritesToggle(item)
        
        XCTAssertTrue(storage.trendingMovies[0].isInFavorites )
        XCTAssertEqual(storage.favoritesMovies.count, 1)
        XCTAssertEqual(storage.favoritesMovies[0].id, item.id)
    }
    
    func test_addToFavorites_syncsBetweenAllLists() {
        let storage = MoviesStorage()
        let item = MockHelper.mockMediaItem
        storage.trendingMovies = [item]
        storage.moviesList = [item]
        
        storage.addToFavorites(item)
        
        XCTAssertTrue(storage.trendingMovies[0].isInFavorites)
        XCTAssertTrue(storage.moviesList[0].isInFavorites)
        XCTAssertEqual(storage.favoritesMovies.count, 1)
    }
    
    func test_addToFavorites_preventsDuplicates() {
        let storage = MoviesStorage()
        let item = MockHelper.mockMediaItem
        
        storage.addToFavorites(item)
        storage.addToFavorites(item)
        
        XCTAssertEqual(storage.favoritesMovies.count, 1)
    }
    
    func test_favoritesToggle_failure_revertsChange() async throws {
        let repo = MockRepository()
        repo.shouldThrowError = true
        
        let storage = MoviesStorage()
        storage.trendingMovies = [MockHelper.mockMediaItem]
        
        let viewModel = TrendingMediaViewModel(repository: repo, mediaStorage: storage)
        
        do {
            try await viewModel.favoritesToggle(storage.trendingMovies[0])
            XCTFail("Should throw error")
        } catch {
            XCTAssertFalse(storage.trendingMovies[0].isInFavorites)
            XCTAssertTrue(storage.favoritesMovies.isEmpty)
        }
    }
    
    func test_discoverMovies_pageHasEnd_shouldReturnNewMovies() {
        let repo = MockRepository()
        let storage = MoviesStorage()
        storage.moviesList = [MockHelper.mockMediaItem, MockHelper.mockMediaItem, MockHelper.mockMediaItem]
        let viewModel = DiscoverMovieViewModel(repository: repo, movieStorage: storage)
        
        XCTAssertTrue(viewModel.hasReachedEnd(of: storage.moviesList.last!))
    }
    
    func test_loadTrendingMedia_firstLoad_fetchesBothTrendingAndFavorites() async throws {
        let repo = MockRepository()
        let storage = MoviesStorage()
        let viewModel = TrendingMediaViewModel(repository: repo, mediaStorage: storage)
        
        try await viewModel.loadTrendingMedia()
        
        XCTAssertFalse(storage.trendingMovies.isEmpty)
        XCTAssertFalse(storage.favoritesMovies.isEmpty)
        XCTAssertEqual(viewModel.viewState, .success)
        XCTAssertTrue(viewModel.isLoaded)
    }
}
