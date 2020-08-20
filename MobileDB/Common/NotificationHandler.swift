//
//  NotificationHandler.swift
//  MobileDB
//
//  Created by Carlos Real on 8/20/20.
//

import UserNotifications

struct NotificationHandler {
  private let center = UNUserNotificationCenter.current()
  private var identifier: String {
    UUID().uuidString
  }
  
  func requestPermission() {
    center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
      if granted {
        print("Permission granted")
      } else {
        print("Permission denied")
      }
    }
  }
  
  func sendNotificationUpdatingImageURL() {
    typealias Copies = Strings.Notification
    
    let content = UNMutableNotificationContent()
    content.title = Copies.title
    content.body = Copies.body
    content.categoryIdentifier = "alarm"
    content.sound = UNNotificationSound.default
    
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
    let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
    
    center.add(request)
  }
}
