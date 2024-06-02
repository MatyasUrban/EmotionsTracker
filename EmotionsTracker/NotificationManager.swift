import Foundation
import UserNotifications

struct NotificationManager {
    
    static let emotionLogNotificationIdentifier = "dailyReminder"
    
    private let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.timeZone = TimeZone.current
        return formatter
    }()
    
    static func requestNotificationAuthorization(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Authorization error: \(error.localizedDescription)")
            }
            DispatchQueue.main.async {
                completion(granted)
            }
        }
    }

    static func scheduleNotification(notificationTimeString: String, identifier: String) {
        guard let date = DateHelper.timeFormatter.date(from: notificationTimeString) else {
            return
        }

        let content = UNMutableNotificationContent()
        content.title = "Reminder"
        content.body = "It's time for your daily entry."
        content.sound = .default

        let dateComponents = Calendar.current.dateComponents([.hour, .minute], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            }
        }
    }


    static func cancelNotification(identifier: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
    }
    
    static func rescheduleNotification(notificationTimeString: String, identifier: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
        scheduleNotification(notificationTimeString: notificationTimeString, identifier: identifier)
    }
}
