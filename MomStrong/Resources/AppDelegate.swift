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

let googleAppID = "2805E95E"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    //    let barButtonAppearance = UIBarButtonItem.appearance()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        UserDefaults.standard.setValue(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
        UNUserNotificationCenter.current().delegate = self
        
        NotificationScheduler.shared.requestNotificationPermission { (success) in
            print(success)
        }
        UIApplication.shared.registerForRemoteNotifications()
        //
        //        let backButtonBackgroundImage = #imageLiteral(resourceName: "BackButton").withRenderingMode(.alwaysOriginal)
        //        barButtonAppearance.setBackButtonBackgroundImage(backButtonBackgroundImage, for: .normal, barMetrics: .default)
        
        
        let discovery = GCKDiscoveryCriteria(applicationID: googleAppID)
        let chromeCastOptions = GCKCastOptions(discoveryCriteria: discovery)
        GCKCastContext.setSharedInstanceWith(chromeCastOptions)
        GCKLogger.sharedInstance().delegate = self
        GCKCastContext.sharedInstance().useDefaultExpandedMediaControls = true
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
    
    // MARK: - Core Data stack
    
    //    lazy var persistentContainer: NSPersistentContainer = {
    /*
     The persistent container for the application. This implementation
     creates and returns a container, having loaded the store for the
     application to it. This property is optional since there are legitimate
     error conditions that could cause the creation of the store to fail.
     */
    //        let container = NSPersistentContainer(name: "MomStrong")
    //        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
    //            if let error = error as NSError? {
    //                // Replace this implementation with code to handle the error appropriately.
    //                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
    //
    //                /*
    //                 Typical reasons for an error here include:
    //                 * The parent directory does not exist, cannot be created, or disallows writing.
    //                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
    //                 * The device is out of space.
    //                 * The store could not be migrated to the current model version.
    //                 Check the error message to determine what the actual problem was.
    //                 */
    //                fatalError("Unresolved error \(error), \(error.userInfo)")
    //            }
    //        })
    //        return container
    //    }()
    
    // MARK: - Core Data Saving support
    
    //    func saveContext () {
    //        let context = persistentContainer.viewContext
    //        if context.hasChanges {
    //            do {
    //                try context.save()
    //            } catch {
    //                // Replace this implementation with code to handle the error appropriately.
    //                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
    //                let nserror = error as NSError
    //                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
    //            }
    //        }
    //    }
    
}


extension AppDelegate: GCKLoggerDelegate{
    
    func logMessage(_ message: String, at level: GCKLoggerLevel, fromFunction function: String, location: String) {
        print(message + " coming from " + function + "@  " + location)
    }
    
}

extension AppDelegate: UNUserNotificationCenterDelegate{
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound, .badge])
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        UserDefaults.standard.set(deviceToken, forKey: "deviceToken")
        UserDefaults.standard.set(true, forKey: "MegsMessageSubscription")
        NotificationScheduler.shared.submitRegisteredAPN(token: deviceToken) { (success) in
            print(success ? "Successfully sent User Token" : "Something Failed sending the APN device token")
        }
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("💩  There was an error in \(#function) ; \(error)  ; \(error.localizedDescription)  💩")
    }
}
