//
//  Constants.swift
//  NetworkApp
//
//  Created by Ivan Behichev on 25.04.2025.
//

import Foundation

enum Constants {
    enum APIKeys {
        static let key: String = Bundle.main.infoDictionary?["API_KEY"] as? String ?? ""
        static let token: String = Bundle.main.infoDictionary?["API_TOKEN"] as? String ?? ""
    }
    
    enum KeychainKeys: String {
        case session = "currentSessionID"
        case userID = "userID" 
    }
    
    enum Design {
        enum LayoutConstants: Double {
            case cornerRadius = 20
            case defaultSpacing = 16
        }
    }
}
