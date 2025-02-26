//
//  HomeViewModel.swift
//  SleepTracker
//
//
//  Created by Alexander Shevtsov on 29.01.2025.
//

import Foundation
import Combine
import SwiftUI

enum TimeView: String, CaseIterable { // временная шкала
    case day, week, month
}

struct SleepData: Identifiable { // вспомогательная инф
    let id = UUID()
    let date: Date
    let sleepDuration: Double // вретя сна
}

final class HomeViewModel: ObservableObject {
    @Published var startAngle: Double = 0 // стартовый угол
    @Published var toAngle: Double = 180 // куда двигаем
    @Published var startProgress: CGFloat = 0 // прогресс
    @Published var toProgress: CGFloat = 0.5 //
    
    @Published var selectedDays: Set<String> = ["Mo", "Tu", "We", "Th", "Fr", "Sa", "Su"]
    @Published var isRemainderEnabled: Bool = false // напоминания
    
    let daysOfWeek: [(id: String, initial: String)] = [
        ("Mo", "M"),
        ("Tu", "T"),
        ("We", "W"),
        ("Th", "T"),
        ("Fr", "F"),
        ("Sa", "S"),
        ("Su", "S")
    ]
    
    @Published var sleepData: [SleepData] = [] // данные по дням
    @Published var filteredSleepData: [SleepData] = []
    @Published var timeView: TimeView = .week
    
    init () {
        generateSample()
        filterSleepData()
    }
    
    func getTime(angle: Double) -> Date {
        let progress = angle / 30
        let hour = Int(progress) % 24
        let remainder = (progress.truncatingRemainder(dividingBy: 1) * 60).rounded()
        let minute = min(Int(remainder), 55)
        
        var components = DateComponents()
        components.hour = hour
        components.minute = minute
        components.second = 0
        
        return Calendar.current.date(from: components) ?? Date()
    }
    
    func getTimeDifference() -> (Int, Int) {
        let calendar = Calendar.current
        let startTime = getTime(angle: startAngle)
        let endTime = getTime(angle: toAngle)
        
        var components = calendar.dateComponents([.hour, .minute], from: startTime, to: endTime)
        
        if components.hour ?? 0 < 0 {
            components.hour = (components.hour ?? 0) + 24
        }
        
        return (components.hour ?? 0, components.minute ?? 0)
    }
    
    func onDrag(value: DragGesture.Value, fromSlider: Bool = true) {
        let vector = CGVector(dx: value.location.x, dy: value.location.y)
        let radians = atan2(vector.dy, vector.dx)
        var angle = radians * 180 / .pi
        
        if angle < 0 {
            angle += 360
        }
        
        let progress = angle / 360
        if fromSlider {
            startAngle = angle
            startProgress = progress
        } else {
            toAngle = angle
            toProgress = progress
        }
    }
    
    func onTapDay(id: String) {
        if selectedDays.contains(id) {
            selectedDays.remove(id)
        } else {
            selectedDays.insert(id)
        }
    }
    
    private func generateSample() {
        let now = Date()
        sleepData = (0..<7).map { i in
            SleepData(
                date: Calendar.current.date(byAdding: .day, value: -i, to: now) ?? now,
                sleepDuration: Double.random(in: 6...8.5)
            )
        }
    }
    
    func filterSleepData() {
        let calendar = Calendar.current
        let now = Date()
        
        switch timeView {
        case .day:
            filteredSleepData = sleepData.filter {
                calendar.isDate($0.date, inSameDayAs: now)
            }
        case .week:
            if let weekAgo = calendar.date(byAdding: .day, value: -7, to: now) {
                filteredSleepData = sleepData.filter {
                    $0.date > weekAgo && $0.date < now
                }
            }
        case .month:
            if let monthAgo = calendar.date(byAdding: .month, value: -1, to: now) {
                filteredSleepData = sleepData.filter {
                    $0.date > monthAgo && $0.date < now
                }
            }
        }
    }
}
