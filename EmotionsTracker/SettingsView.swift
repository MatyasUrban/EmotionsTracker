import SwiftUI

struct SettingsView: View {
    
    @AppStorage("useNameInAffirmation") private var useNameInAffirmation: Bool = false
    @AppStorage("firstName") private var firstName: String = "Name"
    @AppStorage("useReminders") private var useReminders: Bool = false
    @AppStorage("remindersTime") private var remindersTime: String = "12:10"
    @AppStorage("enableCustomTheme") private var enableCustomTheme: Bool = false
    @AppStorage("selectedColorTheme") private var selectedColorTheme: Int = 1
    @State private var remindersDateTime: Date = Date()

    @State private var forceRefresh: Bool = false
    
    
    init() {
        _remindersDateTime = State(initialValue: DateHelper.timeFormatter.date(from: remindersTime) ?? Date())
    }
    
    var settingsItems: [SettingsItem] = [
        .init(name: "Personalized Affirmations", imageName: "person.fill"),
        .init(name: "Notification Reminders", imageName: "alarm.fill"),
        .init(name: "Color Theme", imageName: "paintbrush.fill")
    ]
    
    var body: some View {
        NavigationStack {
            List {
                Section("General") {
                    ForEach(settingsItems, id: \.name) { settingsItem in
                        NavigationLink(value: settingsItem) {
                            Label(settingsItem.name, systemImage: settingsItem.imageName)
                        }
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationDestination(for: SettingsItem.self) { settingsItem in
                switch settingsItem.name {
                case "Personalized Affirmations":
                    Form {
                        Toggle("Personalized affirmations", isOn: $useNameInAffirmation)
                        if useNameInAffirmation {
                            TextField("First name", text: $firstName)
                        }
                        Text("This will include your name within affirmations")
                            .font(.footnote)
                            .foregroundColor(.gray)
                    }
                    .navigationTitle(settingsItem.name)
                    .navigationBarTitleDisplayMode(.inline)
                    
                case "Notification Reminders":
                    Form {
                        Toggle("Notification reminders", isOn: $useReminders)
                            .onChange(of: useReminders) { oldValue, newValue in
                                if newValue {
                                    NotificationManager.requestNotificationAuthorization { granted in
                                        if granted {
                                            NotificationManager.scheduleNotification(notificationTimeString: remindersTime, identifier: NotificationManager.emotionLogNotificationIdentifier)
                                        } else {
                                            useReminders = false
                                        }
                                    }
                                } else {
                                    NotificationManager.cancelNotification(identifier: NotificationManager.emotionLogNotificationIdentifier)
                                }
                            }
                        if useReminders {
                            DatePicker("Notification Time", selection: Binding(
                                get: { DateHelper.timeFormatter.date(from: remindersTime) ?? Date() },
                                set: { newValue in
                                    remindersTime = DateHelper.timeFormatter.string(from: newValue)
                                    NotificationManager.rescheduleNotification(notificationTimeString: remindersTime, identifier: NotificationManager.emotionLogNotificationIdentifier)
                                }
                            ), displayedComponents: .hourAndMinute)
                        }
                        
                        Text("This will send you notifications to log your mood")
                            .font(.footnote)
                            .foregroundColor(.gray)
                    }
                    .navigationTitle(settingsItem.name)
                    .navigationBarTitleDisplayMode(.inline)
                    
                case "Color Theme":
                    Form {
                        Toggle("Enable Custom Theme", isOn: $enableCustomTheme)
                            .onChange(of: enableCustomTheme){ oldValue, newValue in
                                if !newValue {
                                    selectedColorTheme = 1
                                }
                            }
                        if enableCustomTheme {
                            Picker("Select Theme Color", selection: $selectedColorTheme) {
                                ForEach(1...12, id: \.self) { index in
                                    Text(ColorManager.nameFromIndex(index: index)).tag(index)
                                }
                            }
                            .tint(ColorManager.colorFromIndex(index: selectedColorTheme))
                        }
                        
                        Text("This enables you to alter the app's color")
                            .font(.footnote)
                            .foregroundColor(.gray)
                    }
                    .navigationTitle(settingsItem.name)
                    .navigationBarTitleDisplayMode(.inline)
                    .tint(ColorManager.colorFromIndex(index: selectedColorTheme))
                    
                default:
                    EmptyView()
                }
            }
        }
        .accentColor(ColorManager.colorFromIndex(index: selectedColorTheme))
    }
    
}

struct SettingsItem: Hashable {
    let name: String
    let imageName: String
}

extension DateFormatter {
    static let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()
}

#Preview {
    SettingsView()
}

