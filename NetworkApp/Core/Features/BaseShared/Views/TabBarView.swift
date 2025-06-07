//
//  TabBarView.swift
//  NetworkApp
//
//  Created by Ivan Behichev on 24.04.2025.
//

import SwiftUI

struct TabBarView: View {

    @ObservedObject var tabBarCoordinator: TabBarCoordinator
    
    enum Assets: String {
        case trendingImageName = "chart.line.uptrend.xyaxis.circle.fill"
        case favoritesImageName = "star.circle.fill"
        case userImageName = "person.crop.circle.fill"
        case discoverImageName = "movieclapper"
    }
    
    var body: some View {
        TabView(selection: $tabBarCoordinator.selectedTab) {
            
            tabBarCoordinator.trendingTab
                .tabItem {
                    Label("Trending", systemImage: Assets.trendingImageName.rawValue)
                }
                .tag(TabBarItem.trending)

            tabBarCoordinator.discoverTab
                .tabItem {
                    Label("Movies", systemImage: Assets.discoverImageName.rawValue)
                }
                .tag(TabBarItem.discovery)

            tabBarCoordinator.favoritesTab
                .tabItem {
                    Label("Favorites", systemImage: Assets.favoritesImageName.rawValue)
                }
                .tag(TabBarItem.favorite)
            
            tabBarCoordinator.userTab
                .tabItem {
                    Label("Profile", systemImage: Assets.userImageName.rawValue)
                }
                .tag(TabBarItem.userProfile)
        }
    }
}
