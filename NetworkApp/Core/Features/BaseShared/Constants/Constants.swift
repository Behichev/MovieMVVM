//
//  Constants.swift
//  NetworkApp
//
//  Created by Ivan Behichev on 25.04.2025.
//

import Foundation

enum Constants {
    enum APIKeys {
        static let key: String = {
            return Bundle.main.infoDictionary?["API_KEY"] as? String ?? "API_KEY is nil"
        }()
        
        static let token: String = {
            return Bundle.main.infoDictionary?["API_TOKEN"] as? String ?? "API_TOKEN is nil"
        }()
    }
    
    enum KeychainKeys: String {
        case session = "currentSessionID"
        case userID = "userID" 
    }
    
    enum Design {
        enum LayoutConstants: CGFloat {
            case cornerRadius = 20
            case defaultSpacing = 16
        }
    }
}
