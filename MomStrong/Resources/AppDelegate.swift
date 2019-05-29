//
//  AppDelegate.swift
//  MomStrong
//
//  Created by DevMountain on 11/12/18.
//  Copyright © 2018 trevorAdcock. All rights reserved.
//

import UIKit
import CoreData
import GoogleCast
import UserNotifications
import FBSDKCoreKit

let googleAppID = "1DEA39C0"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  //MARK: - Orientation Lock
  /// set orientations you want to be allowed in this property by default
  var orientationLock = UIInterfaceOrientationMask.portrait
  
  func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
    return self.orientationLock
  }
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    UserDefaults.standard.setValue(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
    UNUserNotificationCenter.current().delegate = self
    UNUserNotificationCenter.current().getNotificationSettings { (settings) in
      if settings.authorizationStatus == .authorized {
        print("Notifications Enabled")
        DispatchQueue.main.async {
          UIApplication.shared.registerForRemoteNotifications()
          NotificationScheduler.shared.scheduleNewWorkoutNotification()
        }
      }else{
        print("Notifications Not Enabled")
        NotificationScheduler.shared.requestNotificationPermission { (success) in
          if success{
            DispatchQueue.main.async {
              UIApplication.shared.registerForRemoteNotifications()
              NotificationScheduler.shared.scheduleNewWorkoutNotification()
            }
          }
        }
      }
    }
    
    let discovery = GCKDiscoveryCriteria(applicationID: kGCKDefaultMediaReceiverApplicationID)
    let chromeCastOptions = GCKCastOptions(discoveryCriteria: discovery)
    chromeCastOptions.physicalVolumeButtonsWillControlDeviceVolume = true
    GCKCastContext.setSharedInstanceWith(chromeCastOptions)
    GCKLogger.sharedInstance().delegate = self
    GCKCastContext.sharedInstance().useDefaultExpandedMediaControls = true
    return true
  }
  
  func applicationWillResignActive(_ application: UIApplication) {
//    GCKCastContext.sharedInstance().sessionManager.endSessionAndStopCasting(true)
//    ChromeCastController.shared.sessionManager.endSession()
//    GCKCastContext.sharedInstance().sessionManager.currentCastSession?.end(with: .disconnect)
  }
  
  func applicationDidEnterBackground(_ application: UIApplication) {
//    ChromeCastController.shared.sessionManager.endSession()
//    GCKCastContext.sharedInstance().sessionManager.currentCastSession?.end(with: .disconnect)
  }
  
  func applicationWillEnterForeground(_ application: UIApplication) {
    
  }
  
  func applicationDidBecomeActive(_ application: UIApplication) {
    FBSDKAppEvents.activateApp()
    UserController.shared.fetchCurrentUser { (user, networkError) in
      if networkError == NetworkError.AccountNoLongerActive || user == nil{
        self.window?.rootViewController = UIStoryboard.init(name: "Welcome", bundle: .main).instantiateViewController(withIdentifier: "welcomeNav")
      }
    }
  }
  
  func applicationWillTerminate(_ application: UIApplication) {
    GCKCastContext.sharedInstance().sessionManager.endSessionAndStopCasting(true)
    GCKCastContext.sharedInstance().sessionManager.currentSession?.remoteMediaClient?.stop()
    GCKCastContext.sharedInstance().sessionManager.currentSession?.end(with: .leave)
    GCKCastContext.sharedInstance().sessionManager.currentCastSession?.remoteMediaClient?.stop()
    GCKCastContext.sharedInstance().sessionManager.currentCastSession?.end(with: .stopCasting)
  }
  
  func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
    let handled = FBSDKApplicationDelegate.sharedInstance().application(app, open: url, options: options)
    return handled
  }
}


extension AppDelegate: GCKLoggerDelegate{
  
  func logMessage(_ message: String, at level: GCKLoggerLevel, fromFunction function: String, location: String) {
    print(message + " coming from " + function + "@  " + location)
  }
  
}

extension AppDelegate: UNUserNotificationCenterDelegate{
  
  func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
    print(userInfo)
  }
  
  func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    completionHandler([.alert, .sound, .badge])
  }
  
  func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    NotificationScheduler.shared.deviceToken = deviceToken
    UserDefaults.standard.set(true, forKey: "MegsMessageSubscription")
    let tokenParts = deviceToken.map{ String(format: "%02.2hhx", $0) }
    print(tokenParts.joined())
    NotificationScheduler.shared.submitRegisteredAPN(token: deviceToken) { (success) in
      print(success ? "Successfully sent User Token" : "Something Failed sending the APN device token")
    }
  }
  
  func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
    print("💩  There was an error in \(#function) ; \(error)  ; \(error.localizedDescription)  💩")
  }
}
