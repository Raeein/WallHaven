import UserNotifications

struct NotificationService {
    
    private let dailyReminderIdentifier = "dailyReminder"
    
    func checkAndScheduleNotification() {
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.alert, .sound, .badge]) { _, error in
            if let error {
                print(error.localizedDescription)
            }
        }

        
        center.getPendingNotificationRequests { (requests) in
            if !requests.contains(where: { $0.identifier == dailyReminderIdentifier }) {
                self.scheduleDailyReminder(with: dailyReminderIdentifier)
            }
        }
    }

    private func scheduleDailyReminder(with identifier: String) {
        let center = UNUserNotificationCenter.current()
        
        let content = UNMutableNotificationContent()
        content.title = "Daily Reminder"
        content.body = "Don't forget to check for new wallpapers!"
        content.sound = UNNotificationSound.default
        
        var dateComponents = DateComponents()
        dateComponents.hour = 10

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        center.add(request) { (error) in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }

}
