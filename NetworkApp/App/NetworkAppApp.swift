//
//  NetworkAppApp.swift
//  NetworkApp
//
//  Created by Ivan Behichev on 10.04.2025.
//

import SwiftUI

@main
struct NetworkAppApp: App {

    @StateObject var authentication: Authentication
    private var networkService: NetworkService = NetworkLayer()
    private var imageService: ImageLoaderService = TMDBImageLoader()
    
    init() {
        let authService = AccountService()
        _authentication = StateObject(wrappedValue: Authentication(authService: authService))
    }
    
    var body: some Scene {
        WindowGroup {
            Group {
                if authentication.isAuthenticated {
                    TabBarView(networkService: networkService, imageService: imageService)
                        .environmentObject(authentication)
                } else {
                    LoginView(authService: authentication.authService)
                        .environmentObject(authentication)
                }
            }
        }
    }
}
