//
//  ErrorView.swift
//  NetworkApp
//
//  Created by Ivan Behichev on 09.05.2025.
//

import SwiftUI

struct ErrorView: View {
    
    var errorMessage: String
    var hide: () -> ()
    @State private var offsetY: CGFloat = -150
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundStyle(.white)
                Text(errorMessage)
                    .foregroundStyle(.white)
            }
            .frame(width: 320)
            .padding(.vertical, 24)
            .padding(.horizontal)
            .background {
                RoundedRectangle(cornerRadius: Constants.Design.LayoutConstants.cornerRadius.rawValue)
                    .foregroundStyle(.red.opacity(0.9))
            }
            .offset(y: offsetY)
            
            Spacer()
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                offsetY = 0
            }
        }
        .onDisappear {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.9)) {
                offsetY = -150
            }
        }
        .gesture(
            DragGesture()
                .onChanged { value in
                    if value.translation.height < 0 {
                        offsetY = value.translation.height
                    }
                }
                .onEnded { value in
                    if value.translation.height < -50 {
                        
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.9)) {
                            offsetY = -150
                        }
                        
                        hide()
                        
                    } else {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            offsetY = 0
                        }
                    }
                }
        )
    }
}
