//
//  SplashView.swift
//  NetworkApp
//
//  Created by Ivan Behichev on 21.04.2025.
//

import SwiftUI

struct SplashView: View {
    var body: some View {
        ZStack {
            Color.yellow
                .ignoresSafeArea()
            
            VStack {
                ProgressView("Loading")
                    
            }
        }
    }
}

#Preview {
    SplashView()
}
