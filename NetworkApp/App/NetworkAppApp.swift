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
        if authenticationState.isAuthenticated {
            return .authenticated
        } else {
            return .login
        }
    }
    
    @StateObject var authenticationState: AuthenticationState
    //MARK: Services
    private var networkService: NetworkService = NetworkLayer()
    private var imageService: ImageLoaderService = TMDBImageLoader()
    private var keychainService = KeychainService()
    //MARK: Repositories
    private var trendingRepository: TrendingMediaRepository
    private var favoritesRepository: FavoritesMediaRepository
    private var authRepository: TMDBAuthRepository
    private var userRepository: UserRepository
    private var sessionRepository: SessionRepository
    //MARK: Init
    init() {
        authRepository = TMDBAuthRepositoryImpl(keychainService: keychainService)
        userRepository = TMDBUserRepositoryImpl(networkService: networkService, keychainService: keychainService)
        sessionRepository = SessionRepositoryImpl(networkService: networkService)
        let authenticationState = AuthenticationState(userRepository: userRepository, sessionRepository: sessionRepository, keychainService: keychainService)
        _authenticationState = StateObject(wrappedValue: authenticationState)
        trendingRepository = TrendingMediaRepositoryImpl(networkService: networkService, keychainService: keychainService, imageLoaderService: imageService)
        favoritesRepository = FavoritesMediaRepositoryImpl(networkService: networkService, keychainService: keychainService, imageService: imageService)
        authRepository = TMDBAuthRepositoryImpl(networkService: networkService, keychainService: keychainService)
    }
    //MARK: Scene
    var body: some Scene {
        WindowGroup {
            Group {
                switch appState {
                case .login:
                    LoginView(repository: authRepository)
                        .environmentObject(authenticationState)
                case .authenticated:
                    TabBarView(networkService: networkService, imageService: imageService, trendingRepository: trendingRepository, keychainService: keychainService, favoritesRepository: favoritesRepository, userRepository: userRepository)
                        .environmentObject(authenticationState)
                }
            }
        }
        
    }
}
