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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeBackButton()
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
        
    }
    
    @IBAction func megsMessageNotificationSwitchFlipped(_ sender: Any) {
        
    }
}
