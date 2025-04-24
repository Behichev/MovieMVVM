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
        case authorization
        case validated
        case loading
    }
    
    @State private var isSessionValid: Bool? = nil
    @State private var appState: AppState = .loading
    
    var sessionID = "4309f0534048c0a66eed001b9d1c58c8871054b5"
    var apiKey = "4f8afb35881a873ad0abc5c32dcfbcb1"
    
    private let authService = TMDBAuthService()
    private let validationService = ValidationService()
    
    var body: some Scene {
        WindowGroup {
            Group {
                switch appState {
                case .authorization:
                    LoginView(authService: authService)
                case .validated:
                    TrendingMediaView()
                case .loading:
                    SplashView()
                }
            }
            .task {
                isSessionValid = try? await validationService.validateSession(apiKey, sessionID)
                
                if let isValid = isSessionValid {
                    appState = isValid ? .validated : .authorization
                }
            }
        }
    }
}
