//
//  SleepChartView.swift
//  SleepTracker
//
//  Created by Alexander Shevtsov on 20.02.2025.
//

import SwiftUI
import Charts

struct SleepChartView: View {
    @ObservedObject var homeViewModel = HomeViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                Picker("Time", selection: $homeViewModel.timeView) {
                    ForEach(TimeView.allCases, id: \.self) { view in
                        Text(view.rawValue.capitalized).tag(view)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                onChange(of: homeViewModel.timeView) { _, _ in
                    homeViewModel.filterSleepData()
                }
                
                Chart {
                    RuleMark(y: .value("Target", 7.5))
                        .lineStyle(StrokeStyle(lineWidth: 1, dash: [5]))
                        .annotation(alignment: .leading) {
                            Text("Target")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    ForEach(homeViewModel.filteredSleepData) { data in
                        BarMark(
                            x: .value("Date", data.date, unit: .day),
                            y: .value("Sleep time", data.sleepDuration)
                        )
                        .foregroundStyle(.blue.gradient)
                    }
                }
                .frame(height: 300)
                .chartYScale(domain: 0...10)
                .padding()
                
                Spacer()
            }
            .navigationTitle(Text("Duration of sleep"))
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        homeViewModel.filterSleepData()
                    }) {
                        Image(systemName: "arrow.clockwise")
                    }
                }
            }
        }
    }
}

#Preview {
    SleepChartView()
}
