import SwiftUI
import SwiftData

@main
struct EmotionsTrackerApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    init() {
            UserDefaults.standard.register(defaults: [
                "useNameInAffirmation": false,
                "firstName": "Name",
                "useReminders": false,
                "remindersTime": Date(),
                "enableCustomTheme": false,
                "selectedColorTheme": 1
            ])
        print(URL.applicationSupportDirectory.path(percentEncoded: false))
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: EmotionLog.self)
    }
    
}
