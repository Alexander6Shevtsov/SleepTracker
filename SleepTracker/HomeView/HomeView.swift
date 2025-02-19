//
//  HomeView.swift
//  SleepTracker
//
//  Created by Alexander Shevtsov on 18.02.2025.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var homeViewModel = HomeViewModel()
    var body: some View {
        NavigationView {
            VStack(spacing: 15) {
                
            }
        }
    }
    
    @ViewBuilder func sleepTimeSlider() -> some View {
        GeometryReader { proxy in
            let width = proxy.size.width
            ZStack {
                 let numbers = [12, 15, 18, 21, 0, 3, 6, 9]
                
                ForEach(numbers.indices, id: \.self) {
                    index in Text("\(numbers[index])")
                        .foregroundColor(.secondary)
                        .font(.caption)
                        .rotationEffect(.init(degrees: Double(index) * -45))
                        .offset(y: (width - 90) / 2)
                        .rotationEffect(.init(degrees: Double(index) * 45))
                }
                Circle()
                    
            }
        }
    }
}

#Preview {
    HomeView()
}
