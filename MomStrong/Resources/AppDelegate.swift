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

        //
        //        let backButtonBackgroundImage = #imageLiteral(resourceName: "BackButton").withRenderingMode(.alwaysOriginal)
        //        barButtonAppearance.setBackButtonBackgroundImage(backButtonBackgroundImage, for: .normal, barMetrics: .default)
        
        
//        let discovery = GCKDiscoveryCriteria(applicationID: googleAppID)
//        let chromeCastOptions = GCKCastOptions(discoveryCriteria: discovery)
//        GCKCastContext.setSharedInstanceWith(chromeCastOptions)
//        GCKLogger.sharedInstance().delegate = self
//        GCKCastContext.sharedInstance().useDefaultExpandedMediaControls = true
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        
        GCKCastContext.sharedInstance().sessionManager.currentCastSession?.end(with: .disconnect)
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        GCKCastContext.sharedInstance().sessionManager.currentCastSession?.end(with: .disconnect)
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        GCKCastContext.sharedInstance().sessionManager.currentCastSession?.end(with: .stopCasting)
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
        
        UserDefaults.standard.set(deviceToken, forKey: "deviceToken")
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
