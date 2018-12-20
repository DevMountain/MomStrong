//
//  NotificationSettingsViewController.swift
//  MomStrong
//
//  Created by DevMountain on 12/10/18.
//  Copyright © 2018 trevorAdcock. All rights reserved.
//

import UIKit

class NotificationSettingsViewController: UIViewController {
    
    @IBOutlet weak var megMessageSwitch: UISwitch!
    @IBOutlet weak var newWorkoutsSwitch: UISwitch!
    
    var isSubscribedToNewWorkouts: Bool?
    
    var isSubscribedForMegsMessage: Bool{
        return UserDefaults.standard.bool(forKey: "MegsMessageSubscription")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeBackButton()
        setSubscribedForNewWorkoutSwitch()
        megMessageSwitch.setOn(isSubscribedForMegsMessage, animated: false)
    }
    
    func setSubscribedForNewWorkoutSwitch(){
        NotificationScheduler.shared.isUserRegisteredForNotifications { (subscribed) in
            DispatchQueue.main.async {
                self.isSubscribedToNewWorkouts = subscribed
                self.newWorkoutsSwitch.setOn(subscribed, animated: true)
            }
        }
    }
    
    func toggleSubscriptionSwitch(){
        isSubscribedToNewWorkouts?.toggle()
        self.newWorkoutsSwitch.setOn(isSubscribedToNewWorkouts ?? false, animated: true)
    }
    
    @discardableResult
    func toggleIsSubscriptionForMegsMessage() -> Bool{
        let subscribed = !isSubscribedForMegsMessage
        UserDefaults.standard.set(subscribed, forKey: "MegsMessageSubscription")
        
        if subscribed{ NotificationScheduler.shared.unsubscribeFromMegsMessageAPNs { (_) in }
        }else{
            guard let token = UserDefaults.standard.value(forKey: "deviceToken") as? Data else { return subscribed}
            NotificationScheduler.shared.submitRegisteredAPN(token: token) { (_) in }
        }
        megMessageSwitch.setOn(isSubscribedForMegsMessage, animated: false)
        return subscribed
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func newWorkoutsNotficationSwitchFlipped(_ sender: Any) {
        NotificationScheduler.shared.toggleNewWorkoutNotifications()
        toggleSubscriptionSwitch()
    }
    
    @IBAction func megsMessageNotificationSwitchFlipped(_ sender: Any) {
        
        
    }
}
