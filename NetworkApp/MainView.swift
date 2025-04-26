//
//  MainView.swift
//  NetworkApp
//
//  Created by Ivan Behichev on 24.04.2025.
//

import SwiftUI

struct MainView: View {
    
    var body: some View {
        TabView {
                TrendingMediaView()
                .tabItem {
                    Label("Tranding", systemImage: "chart.line.uptrend.xyaxis.circle.fill")
                }
                
            FavoritesMoviesView()
                .tabItem {
                    Label("Favorites", systemImage: "star.circle.fill")
                }
            
            AccountView()
                .tabItem {
                    Label("Account", systemImage: "person.crop.circle.fill")
                }
        }
    }
}

#Preview {
    MainView()
}
