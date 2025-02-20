//
//  SleepChatView.swift
//  SleepTracker
//
//  Created by Alexander Shevtsov on 20.02.2025.
//

import SwiftUI
import Charts

struct SleepChatView: View {
    @ObservableObject var homeViewModel = HomeViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                Picker("Time", selection: $homeViewModel.timeView) {
                    ForEach(TimeView.allCases, id: \.self) {
                        view in
                        Text(view.rawValue.capitalized).tag(view)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                onChange(of: homeViewModel.timeView) {
                    homeViewModel.filterSleepData()
                }
                Chart {
                    RuleMark(y: .value("Target", 7.5))
                        .lineStyle(StrokeStyle(lineWidth: 1, dash: [5]))
                        .annotation()
                }
            }
        }
    }
}

#Preview {
    SleepChatView()
}
