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
  var deviceToken: Data?
  
  let baseUrl = URL(string: "https://www.momstrongmove.com/api")
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
    notificationContent.title = "New Workouts Available"
    notificationContent.body = "The perfect opportunity for a fresh start!"
    var triggerComponents = DateComponents()
    triggerComponents.weekday = 2
    triggerComponents.hour = 6
    triggerComponents.minute = 0
    triggerComponents.second = 0
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
  
  func isUserRegisteredForNotifications(completion: @escaping (Bool) -> Void){
    UNUserNotificationCenter.current().getPendingNotificationRequests { (requests) in
      let filteredRequests = requests.filter{ $0.identifier  == MomStrongNotifications.NewWorkouts.rawValue }
      completion(!filteredRequests.isEmpty)
    }
  }
  
  func toggleNewWorkoutNotifications(){
    isUserRegisteredForNotifications { (subscribed) in
      subscribed ? self.cancelNotifications(for: [.NewWorkouts]) : self.scheduleNewWorkoutNotification()
    }
  }
  
  func submitRegisteredAPN(for user: User? = UserController.shared.currentUser, token: Data? = NotificationScheduler.shared.deviceToken, completion: @escaping (Bool) -> ()){
    guard let user = user, let token = deviceToken else { completion(false) ; return }
    guard var url = baseUrl?.appendingPathComponent("user").appendingPathComponent("deviceToken") else { return }
    url.appendPathComponent("\(user.id)")
    var request = URLRequest(url: url)
    let tokenParts = token.map{ String(format: "%02.2hhx", $0) }
    let tokenString = tokenParts.joined()
    print(tokenString)
    let jsonBody = ["device_token" : tokenString]
    request.httpBody = try? JSONEncoder().encode(jsonBody)
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpMethod = "PUT"
    
    URLSession.shared.dataTask(with: request) { (data, response, error) in
      if let error = error{
        print("\(error.localizedDescription) \(error) in function: \(#function)")
        completion(false)
        return
      }else{
        UserDefaults.standard.set(true, forKey: "MegsMessageSubscription")
        completion(true)
      }
      }.resume()
  }
  
  func unsubscribeFromMegsMessageAPNs(for user: User? = UserController.shared.currentUser, completion: @escaping (Bool) -> ()){
    UserDefaults.standard.set(false, forKey: "MegsMessageSubscription")
    submitRegisteredAPN(for: user, token: nil, completion: completion)
  }
  
  func fetchMegsCurrentMessage(completion: @escaping (String?) -> ()){
    guard let url = baseUrl?.appendingPathComponent("megsMessage/current") else { completion(nil) ; return }
    let request = URLRequest(url: url)
    URLSession.shared.dataTask(with: request) { (data, response, error) in
      if let error = error{
        print("\(error.localizedDescription) \(error) in function: \(#function)")
        completion(nil)
        return
      }
      
      print(response ?? "No Response")
      
      guard let data = data else {completion(nil) ; return}
      
      do{
        let jsonArray = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [[String : Any]]
        let message = jsonArray?.first?["message"] as? String
        completion(message)
      }catch {
        print("There was as error in \(#function) :  \(error) \(error.localizedDescription)")
        completion(nil)
      }
      }.resume()
  }
}

enum MomStrongNotifications: String{
  case NewWorkouts = "New Workout Notifications"
  case MegsMessage = "Megs Message Notifications"
}
