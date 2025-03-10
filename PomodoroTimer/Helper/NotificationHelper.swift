//
//  NotificationHelper.swift
//  PomodoroTimer
//
//  Created by Bayram Yeleç on 10.03.2025.
//

import UserNotifications

class NotificationHelper {
    
    static func sendNotification(title: String, body: String, sound: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        
        if sound == "bell" {
            content.sound = UNNotificationSound(named: UNNotificationSoundName("bell.mp3"))
        } else if sound == "chime" {
            content.sound = UNNotificationSound(named: UNNotificationSoundName("chime.mp3"))
        } else {
            content.sound = .default
        }
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Bildirim gönderme hatası: \(error.localizedDescription)")
            }
        }
    }
}

