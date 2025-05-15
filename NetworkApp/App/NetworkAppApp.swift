//
//  NetworkAppApp.swift
//  NetworkApp
//
//  Created by Ivan Behichev on 10.04.2025.
//

import SwiftUI

@main
struct NetworkAppApp: App {
    //MARK: App State
    enum AppState {
        case login
        case authenticated
    }
    
    private var appState: AppState {
        if authenticationStore.isAuthenticated {
            return .authenticated
        } else {
            return .login
        }
    }
    
    @StateObject var authenticationStore: AuthenticationStore
    //MARK: Services
    private var networkService: NetworkService = NetworkLayer()
    private var imageService: ImageLoaderService = TMDBImageLoader()
    private var keychainService = KeychainService()
    private var moviesStorage = MoviesStorage()
    //MARK: Repositories
    private var repository: TMDBRepositoryProtocol
    //MARK: Init
    init() {
        repository = TMDBRepository(networkService: networkService,
                                    imageService: imageService,
                                    keychainService: keychainService, dataSource: moviesStorage)
        let authenticationStore = AuthenticationStore(repository: repository,
                                                      keychainService: keychainService)
        _authenticationStore = StateObject(wrappedValue: authenticationStore)
    }
    //MARK: Scene
    var body: some Scene {
        WindowGroup {
            Group {
                switch appState {
                case .login:
                    LoginView(repository: repository)
                        .environmentObject(authenticationStore)
                case .authenticated:
                    TabBarView(networkService: networkService,
                               imageService: imageService,
                               repository: repository,
                               keychainService: keychainService)
                        .environmentObject(authenticationStore)
                }
            }
        }
        
    }
}
