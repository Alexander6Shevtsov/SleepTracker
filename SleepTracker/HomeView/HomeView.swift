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
        NavigationStack {
            VStack(spacing: 15) {
                sleepTimeSlider()
                
                HStack {
                    Image(systemName: "moon.fill")
                    VStack {
                        Text(
                            homeViewModel
                                .getTime(angle: homeViewModel.startAngle)
                                .formatted(date: .omitted, time: .shortened)
                        )
                        .font(.title.bold())
                        Text("Sleep Dawn")
                            .font(.subheadline)
                            .foregroundStyle(.gray)
                    }
                    Spacer()
                    Image(systemName: "alarm.fill")
                    VStack {
                        Text(
                            homeViewModel
                                .getTime(angle: homeViewModel.toAngle)
                                .formatted(date: .omitted, time: .shortened)
                        )
                        .font(.title.bold())
                        Text("Wake Up")
                            .font(.subheadline)
                            .foregroundStyle(.gray)
                    }
                }
                .padding(.horizontal)
                
                HStack {
                    Text("Choose Days")
                        .font(.headline).bold()
                    Spacer()
                }
                .padding([.top, .horizontal])
                
                HStack {
                    ForEach(homeViewModel.daysOfWeek, id: \.id) { day in
                        Text(day.initial)
                            .frame(width: 42, height: 42)
                            .background(
                                homeViewModel.selectedDays.contains(day.id)
                                ? Color.gray.opacity(0.3)
                                : .primary
                            )
                            .foregroundStyle(
                                homeViewModel.selectedDays.contains(day.id)
                                ? .black
                                : .white
                            )
                            .clipShape(Circle())
                            .onTapGesture {
                                homeViewModel.onTapDay(id: day.id)
                            }
                    }
                }
                .padding(.bottom)
                
                HStack {
                    Text("Remind me")
                        .font(.headline)
                    Spacer()
                    Toggle("", isOn: $homeViewModel.isRemainderEnabled)
                }
                .padding()
                .background(.white)
                .cornerRadius(20)
                .shadow(radius: 2)
                .tint(.primary)
            }
            .navigationTitle("Sleep Tracker")
            .navigationBarTitleDisplayMode(.large)
            .padding()
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: SettingsView()) {
                        Image(systemName: "gearshape")
                            .imageScale(.large)
                    }
                }
            }
        }
    }
    
    @ViewBuilder func sleepTimeSlider() -> some View {
        GeometryReader { proxy in
            let width = proxy.size.width
            ZStack {
                let numbers = [12, 15, 18, 21, 0, 3, 6, 9]
                ForEach(numbers.indices, id: \.self) { index in
                    Text("\(numbers[index])")
                        .foregroundColor(.secondary)
                        .font(.caption)
                        .rotationEffect(.degrees(Double(index) * -45))
                        .offset(y: (width - 90) / 2)
                        .rotationEffect(.degrees(Double(index) * 45))
                }
                
                Circle()
                    .stroke(Color.black.opacity(0.06), lineWidth: 40)
                
                let reverseRotation = homeViewModel.startProgress > homeViewModel.toProgress
                ? Double((1 - homeViewModel.startProgress) * 360)
                : 0
                Circle()
                    .trim(
                        from: homeViewModel.startProgress > homeViewModel.toProgress
                          ? 0
                          : homeViewModel.startProgress,
                          to: homeViewModel.toProgress
                    )
                    .stroke(
                        Color.black,
                        style: StrokeStyle(
                            lineWidth: 40,
                            lineCap: .round,
                            lineJoin: .round
                        )
                    )
                    .rotationEffect(.degrees(-90 + reverseRotation))
                
                SliderKnob(angle: homeViewModel.startAngle, systemImage: "moon.stars.fill") {
                    homeViewModel.onDrag(value: $0, fromSlider: true)
                }
                .offset(x: width / 2)
                
                SliderKnob(angle: homeViewModel.startAngle, systemImage: "alarm.fill") {
                    homeViewModel.onDrag(value: $0)
                }
                .offset(x: width / 2)
                
                HStack(spacing: 8) {
                    let difference = homeViewModel.getTimeDifference()
                    Text("\(difference.0)h \(difference.1)m")
                        .font(.title)
                        .fontWeight(.medium)
                }
            }
        }
    }
}

struct SliderKnob: View {
    let angle: Double
    let systemImage: String
    let onDrag: (DragGesture.Value) -> Void
    
    var body: some View {
        Image(systemName: systemImage)
            .font(.body)
            .frame(width: 30, height: 30)
            .background(Circle().fill(Color.white))
            .rotationEffect(.degrees(90 - angle))
            .gesture(DragGesture().onChanged(onDrag))
    }
}

#Preview {
    HomeView()
}
