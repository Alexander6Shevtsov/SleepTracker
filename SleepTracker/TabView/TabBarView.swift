//
//  TabView.swift
//  SleepTracker
//
//  Created by Alexander Shevtsov on 20.02.2025.
//

import SwiftUI

struct TabBarView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Image(systemName: "house")
                    Text("Main")
                }
                .onAppear() {
                    selectedTab = 0
                }
                .tag(0)
            SleepChartView()
                .tabItem {
                    Image(systemName: "chart.bar.xaxis")
                    Text("Schedule")
                }
                .onAppear() {
                    selectedTab = 1
                }
                .tag(1)
            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape")
                    Text("Settings")
                }
                .onAppear() {
                    selectedTab = 2
                }
                .tag(2)
        }
    }
}

#Preview {
    TabBarView()
}
