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
    
    private var appState: AppState {
        if authentication.isAuthenticated {
            return .authenticated
        } else {
            return .login
        }
    }
    
    init() {
        let authService = AccountService()
        _authentication = StateObject(wrappedValue: Authentication(authService: authService))
    }
    
    var body: some Scene {
        WindowGroup {
            Group {
                switch appState {
                case .login:
                    LoginView(authService: authentication.authService)
                        .environmentObject(authentication)
                case .authenticated:
                    TabBarView(networkService: networkService, imageService: imageService)
                        .environmentObject(authentication)
                }
            }
        }
    }
}
