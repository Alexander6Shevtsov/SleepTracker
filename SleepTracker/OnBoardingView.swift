//
//  OnBoardingView.swift
//  SleepTracker
//
//  Created by Alexander Shevtsov on 20.02.2025.
//

import SwiftUI

struct OnBoardingView: View {
    
    @AppStorage("isOnboarding") private var isOnboarding = true
    
    private let onboardingPages: [OnboardingPageModel] = [
        .init(image: "moon.logo", title: "Watch your sleep", description: "Find out the characteristics of your sleep and naps"),
        .init(image: "alarm.fill", title: "Set alarms", description: "Easily manage your wake-up time")
    ]
    
    var body: some View {
        if isOnboarding {
            NavigationStack {
                TabView {
                    ForEach(onboardingPages) { page in
                        OnboardingPage(model: page)
                    }
                    StartButton(isOnboarding: $isOnboarding)
                }
                .tabViewStyle(PageTabViewStyle())
                .navigationTitle("Sleep Tracker")
            }
        } else {
            TabBarView()
        }
    }
}

private struct StartButton: View {
    @Binding var isOnboarding: Bool

    var body: some View {
        VStack {
            Button("Start") {
                isOnboarding.toggle()
            }
            .frame(width: 300, height: 55)
            .font(.title2)
            .background(.black)
            .cornerRadius(20)
            .foregroundStyle(.white)
            
            Text("By continuing, you agree to the User Agreement")
                .font(.footnote)
                .multilineTextAlignment(.center)
        }
    }
}

// MARK: - OnboardingPage Model & View

struct OnboardingPageModel: Identifiable {
    let id = UUID()
    let image: String
    let title: String
    let description: String
}

struct OnboardingPage: View {
    let model: OnboardingPageModel

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: model.image)
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)

            Text(model.title)
                .font(.title)
                .fontWeight(.bold)

            Text(model.description)
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
    }
}

#Preview {
    OnBoardingView()
}

