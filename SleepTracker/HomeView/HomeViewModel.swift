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
    
//    func getDateComponents(for day: String) -> DateComponents {
//        var components = DateComponents()
//        let startDate = getTime(angle: startAngle)
//        let calendar = Calendar.current
//        let notificationsDate = calendar.date(
//            byAdding: .minute,
//            value: -30,
//            to: startDate
//        ) ?? startDate
//        
//        let dateComponents = calendar.dateComponents([.hour, .minute], from: notificationsDate)
//        components.hour = dateComponents.hour
//        components.minute = dateComponents.minute
//        components.second = 0
//        switch day {
//        case "Mo": components.weekday = 1
//        case "Tu": components.weekday = 2
//        case "We": components.weekday = 3
//        case "Th": components.weekday = 4
//        case "Fr": components.weekday = 5
//        case "Sa": components.weekday = 6
//        case "Su": components.weekday = 7    // попробуй сделать default
//        default : break
//        }
//        
//        return components
//    }
    
    func getTime(angle: Double) -> Date {
        let progress = angle / 30
        let hour = Int(progress) % 24
        let remainder = (progress.truncatingRemainder(dividingBy: 1) * 60).rounded()
        let minute = min(Int(remainder), 55)

        var components = DateComponents()
        components.hour = hour
        components.minute = minute
        components.second = 0
                         
        let calendar = Calendar.current
        return calendar.date(from: components) ?? Date()
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
        sleepData = [
            SleepData(date: Date().addingTimeInterval(-84600 * 6), sleepDuration: 7.0),
            SleepData(date: Date().addingTimeInterval(-84600 * 5), sleepDuration: 6.0),
            SleepData(date: Date().addingTimeInterval(-84600 * 4), sleepDuration: 8.3),
            SleepData(date: Date().addingTimeInterval(-84600 * 3), sleepDuration: 7.0),
            SleepData(date: Date().addingTimeInterval(-84600 * 2), sleepDuration: 7.5),
            SleepData(date: Date().addingTimeInterval(-84600 * 1), sleepDuration: 7.2),
            SleepData(date: Date(), sleepDuration: 8.0)
        ]
    }
    
    func filterSleepData() {
        let calendar = Calendar.current
        let now = Date()
        
        switch timeView {
        case .day:
            filteredSleepData = sleepData.filter({
                calendar.isDate($0.date, inSameDayAs: now)
            })
        case .week:
            if let weekAgo = calendar.date(byAdding: .day, value: -7, to: now) {
                filteredSleepData = sleepData.filter({
                    $0.date > weekAgo && $0.date < now
                })
            }
        case .month:
            if let monthAgo = calendar.date(byAdding: .month, value: -1, to: now) {
                filteredSleepData = sleepData.filter({
                    $0.date > monthAgo && $0.date < now
                })
            }
        }
    }
}
