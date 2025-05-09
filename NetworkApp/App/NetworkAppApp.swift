//
//  NetworkAppApp.swift
//  NetworkApp
//
//  Created by Ivan Behichev on 10.04.2025.
//

import SwiftUI

@main
struct NetworkAppApp: App {
    
    enum AppState {
        case login
        case authenticated
    }

    @StateObject var authentication: Authentication
    
    private var networkService: NetworkService = NetworkLayer()
    private var imageService: ImageLoaderService = TMDBImageLoader()
    private var trendingRepository: TrendingMediaRepository
    private var keychainService = KeychainManager()
    
    private var appState: AppState {
        if authentication.isAuthenticated {
            return .authenticated
        } else {
            return .login
        }
    }
    
    init() {
           let authService = AccountService(keychainService: keychainService)
           let auth = Authentication(authService: authService, keychainService: keychainService)
           _authentication = StateObject(wrappedValue: auth)
           trendingRepository = TrendingMediaRepository(networkService: networkService, keychainService: keychainService, imageLoaderService: imageService)
       }
    
    var body: some Scene {
        WindowGroup {
            Group {
                switch appState {
                case .login:
                    LoginView(authService: authentication.authService)
                        .environmentObject(authentication)
                case .authenticated:
                    TabBarView(networkService: networkService, imageService: imageService, trendingRepository: trendingRepository, keychainService: keychainService)
                        .environmentObject(authentication)
                }
            }
        }
    }
}
