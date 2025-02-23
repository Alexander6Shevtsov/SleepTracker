//
//  SettingsView.swift
//  SleepTracker
//
//  Created by Alexander Shevtsov on 20.02.2025.
//

import SwiftUI
import UserNotifications

final class SettingsViewModel: ObservableObject {
    @AppStorage("username") var username: String = ""
    @AppStorage("email") var email: String = ""
    @Published var isNotificationsEnabled = false {
        didSet {
            if isNotificationsEnabled {
                enableNotifications()
            }
        }
    }
    
    private func enableNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(
            options: [.alert, .badge, .sound]
        ) { success, error in
            DispatchQueue.main.async {
                if success {
                    print("Notification enable")
                } else if let error = error {
                    print("Error: \(error.localizedDescription)")
                } else {
                    print("User denied notifications")
                }
            }
        }
    }
}

struct SettingsView: View {
    @StateObject private var settingsViewModel = SettingsViewModel()
    @State var hours: Int = 0
    @State var minutes: Int = 0
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Profile")) {
                    TextField("Name user", text:$settingsViewModel.username)
                    TextField("Email", text:$settingsViewModel.email)
                    Toggle("Notifications", isOn: $settingsViewModel.isNotificationsEnabled)
                }
                
                Section(header: Text("Dream")) {
                        Picker("My target", selection: $hours) {
                            ForEach(1..<12, id: \.self) { hour in
                                Text("\(hour)h").tag(hour)
                            }
                        }
                        .pickerStyle(.wheel)
                        
                        Picker("Minutes", selection: $minutes) {
                            ForEach(0..<60, id: \.self) { minute in
                                Text("\(minute)m").tag(minute)
                            }
                        }
                        .pickerStyle(.wheel)
                }
                
                Section(header: Text("General")) {
                    Text("About App")
                }
            }
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    NavigationStack {
        SettingsView()
    }
}
