import Foundation
import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()
    
    private init() {}
    
    private let notificationTimeKey = "notificationTimeKey"
    
    func requestAuthorization(completion: @escaping (Bool, Error?) -> Void) {
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        UNUserNotificationCenter.current().requestAuthorization(options: options, completionHandler: completion)
    }
    
    func scheduleDailyNotification(title: String, subtitle: String, hour: Int, minute: Int) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = subtitle
        content.sound = .default
        content.badge = 1
        
        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("ERROR: \(error)")
            } else {
                print("Daily notification scheduled")
                self.saveNotificationTime(hour: hour, minute: minute)
            }
        }
    }
    
    func saveNotificationTime(hour: Int, minute: Int) {
        let timeString = String(format: "%02d:%02d", hour, minute)
        UserDefaults.standard.set(timeString, forKey: notificationTimeKey)
    }
    
    func getNotificationTime() -> String? {
        return UserDefaults.standard.string(forKey: notificationTimeKey)
    }
}
