//
//  NetworkAppSnapshotTest.swift
//  NetworkAppSnapshotTest
//
//  Created by Ivan Behichev on 02.07.2025.
//

@testable import NetworkApp
import XCTest
import SnapshotTesting

final class NetworkAppSnapshotTest: XCTestCase {
    
    func test_notInFavorites_icon() {
        var item = MockHelper.mockMediaItem
        item.isInFavorites = false
        let view = MediaPreviewCell(media: item) { _ in
            await MockHelper.setImage("")
        } onFavoritesTapped: {
            print("Im  not favorite")
        }
        
        assertSnapshot(of: view, as: .image(precision: 1 ,
                                            layout: .device(config: .iPhone13),
                                            traits: UITraitCollection(userInterfaceStyle: .light)
                                           )
        )
    }
    
    func test_inFavorites_icon() {
        var item = MockHelper.mockMediaItem
        item.isInFavorites = true
        let view = MediaPreviewCell(media: item) { _ in
            await MockHelper.setImage("")
        } onFavoritesTapped: {
            print("Im favorite")
        }
        
        assertSnapshot(of: view, as: .image(precision: 1 ,
                                            layout: .device(config: .iPhone13),
                                            traits: UITraitCollection(userInterfaceStyle: .light)
                                           )
        )
    }
    
    func test_trendingMediaView_darkAppearance() {
        let repo = MockRepository()
        let storage = MockMovieStorage()
        let tabBarCoordinator = TabBarCoordinator(repository: repo, mediaStorage: storage)
        let tabBar = TabBarView(repository: repo, mediaStorage: storage, tabBarCoordinator: tabBarCoordinator)
        
        assertSnapshot(of: tabBar, as: .image(precision: 1 ,
                                              layout: .device(config: .iPhone13),
                                              traits: UITraitCollection(userInterfaceStyle: .dark)
                                             )
        )
        
    }
    
    func test_trendingMediaView_lightAppearance() {
        let repo = MockRepository()
        let storage = MockMovieStorage()
        let tabBarCoordinator = TabBarCoordinator(repository: repo, mediaStorage: storage)
        let tabBar = TabBarView(repository: repo, mediaStorage: storage, tabBarCoordinator: tabBarCoordinator)
        
        assertSnapshot(of: tabBar, as: .image(precision: 1 ,
                                              layout: .device(config: .iPhone13),
                                              traits: UITraitCollection(userInterfaceStyle: .light)
                                             )
        )
        
    }
    
    func test_trendingMediaView_emptyState() {
        let repo = MockRepository()
        let storage = MockMovieStorage()
        storage.trendingMovies = []
        let tabBarCoordinator = TabBarCoordinator(repository: repo, mediaStorage: storage)
        let tabBar = TabBarView(repository: repo, mediaStorage: storage, tabBarCoordinator: tabBarCoordinator)
        
        assertSnapshot(of: tabBar, as: .image(precision: 1 ,
                                              layout: .device(config: .iPhone13),
                                              traits: UITraitCollection(userInterfaceStyle: .light)
                                             )
        )
    }
}

