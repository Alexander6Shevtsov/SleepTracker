//
//  OnBoardingView.swift
//  SleepTracker
//
//  Created by Alexander Shevtsov on 20.02.2025.
//

import SwiftUI

struct OnBoardingView: View {
    
    @AppStorage("isOnboarding") var isOnboarding = true
    
    var body: some View {
        if isOnboarding {
            NavigationStack {
                TabView {
                    VStack {
                        Image("moon.logo")
                            .resizable()
                        VStack(spacing: 15) {
                            Text("Watch your sleep")
                                .font(.title)
                                .fontWeight(.bold)
                            Text("Find out the characteristics of your sleep and naps")
                                .font(.subheadline)
                                .fontWeight(.bold)
                            Button("Start") {
                                isOnboarding.toggle()
                            }
                            .frame(width: 300, height: 55)
                            .font(.title2)
                            .background(.black)
                            .cornerRadius(20)
                            .foregroundStyle(.white)
                            VStack {
                                Text("By continuing, you agree to the User Agreement")
                            }
                            .font(.footnote)
                            .multilineTextAlignment(.center)
                        }
                    }
                }
                .navigationTitle("Sleep Tracker")
                .tabViewStyle(.automatic)
            }
        } else {
            TabBarView()
        }
    }
}

#Preview {
    OnBoardingView()
}
