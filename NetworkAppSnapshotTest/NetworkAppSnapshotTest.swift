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
    
    func test_loginView_normalState() {
        let repository = MockRepository()
        let view = LoginView(repository: repository)
            .environment(AuthenticationStore(repository: repository, keychainService: KeychainService()))
        assertSnapshot(of: view, as: .image(precision: 1 ,
                                              layout: .device(config: .iPhone13),
                                              traits: UITraitCollection(userInterfaceStyle: .light)
                                             )
        )
    }
    
    func test_loginView_invalidCredentials() {
        let repository = MockRepository()
        let setupView = LoginView(repository: repository)
        setupView.viewModel.credentials = Credentials(username: "Invalid", password: "Credentials")
        setupView.viewModel.isInvalidCredentials = true
        
        let view = setupView
            .environment(AuthenticationStore(repository: repository, keychainService: KeychainService()))
        
        assertSnapshot(of: view, as: .image(precision: 1 ,
                                              layout: .device(config: .iPhone13),
                                              traits: UITraitCollection(userInterfaceStyle: .light)
                                             )
        )
    }
    
    func test_loginView_showPassword() {
        let repository = MockRepository()
        let setupView = LoginView(repository: repository)
        setupView.viewModel.credentials = Credentials(username: "UserName", password: "Password")
        setupView.viewModel.isPasswordVisible = true
        
        let view = setupView
            .environment(AuthenticationStore(repository: repository, keychainService: KeychainService()))
        
        assertSnapshot(of: view, as: .image(precision: 1 ,
                                              layout: .device(config: .iPhone13),
                                              traits: UITraitCollection(userInterfaceStyle: .light)
                                             )
        )
    }
}

