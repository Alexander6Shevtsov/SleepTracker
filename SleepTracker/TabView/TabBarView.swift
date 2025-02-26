//
//  TabBarView.swift
//  SleepTracker
//
//  Created by Alexander Shevtsov on 20.02.2025.
//

import SwiftUI

struct TabBarView: View {
    @AppStorage("selectedTab") private var selectedTab = 0
    
    private let tabs: [(view: AnyView, icon: String, title: String)] = [
        (AnyView(HomeView()), "house", "Main"),
        (AnyView(SleepChartView()), "chart.bar.xaxis", "Schedule"),
        (AnyView(SettingsView()), "gearshape", "Settings")
    ]

    var body: some View {
        TabView(selection: $selectedTab) {
            ForEach(Array(tabs.enumerated()), id: \.offset) { index, tab in
                tab.view
                    .tabItem {
                        Image(systemName: tab.icon)
                        Text(tab.title)
                    }
                    .tag(index)
            }
        }
    }
}

#Preview {
    TabBarView()
}
