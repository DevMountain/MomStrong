//
//  NotificationController.swift
//  MomStrong
//
//  Created by DevMountain on 12/10/18.
//  Copyright © 2018 trevorAdcock. All rights reserved.
//

import Foundation
import UserNotifications

class NotificationScheduler{
    
    static let shared = NotificationScheduler()
    
    var permissionGranted: Bool = false
    
    func requestNotificationPermission(completion: @escaping (Bool) -> ()){
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if let error = error {
                print("💩  There was an error in \(#function) ; \(error)  ; \(error.localizedDescription)  💩")
                completion(false)
            }
            self.permissionGranted = granted
            completion(granted)
        }
    }
    
    func scheduleNewWorkoutNotification() {
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = "New Workouts Available!"
        notificationContent.body = "The perfect opportunity for a fresh start"
        
        var triggerComponents = DateComponents()
        triggerComponents.day = 1
        triggerComponents.hour = 6
        let dateTrigger = UNCalendarNotificationTrigger(dateMatching: triggerComponents, repeats: true)
        let request = UNNotificationRequest(identifier: MomStrongNotifications.NewWorkouts.rawValue, content: notificationContent, trigger: dateTrigger)
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("Unable to add notification request. \(error.localizedDescription)")
            } else {
                print("Successfully subscribed to New Workout Notifications")
            }
        }
    }
    
    func cancelNotifications(for notifications: [MomStrongNotifications]) {
        let notificationIDs = notifications.compactMap{ $0.rawValue }
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: notificationIDs)
    }
    
    func toggleNewWorkoutNotifications(){
        UNUserNotificationCenter.current().getPendingNotificationRequests { (requests) in
            let filteredRequests = requests.filter{ $0.identifier  == MomStrongNotifications.NewWorkouts.rawValue }
            if !filteredRequests.isEmpty{
                self.cancelNotifications(for: [.NewWorkouts])
            }else {
                self.scheduleNewWorkoutNotification()
            }
        }
    }
    
    func submitRegisteredAPN(for user: User? = UserController.shared.currentUser, token: Data, completion: @escaping (Bool) -> ()){
        
        guard let user = user else { completion(false) ; return }
        guard var url = URL(string: "http://138.197.192.102:3691/api/user/deviceToken/") else { return }
        url.appendPathComponent("\(user.id)")
        
        var request = URLRequest(url: url)
        request.httpBody = token
        request.httpMethod = "POST"
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error{
                print("\(error.localizedDescription) \(error) in function: \(#function)")
                completion(false)
                return
            }else{
                completion(true)
            }
            }.resume()
    }
}

enum MomStrongNotifications: String{
    case NewWorkouts = "New Workout Notifications"
    case MegsMessage = "Megs Message Notifications"
}
