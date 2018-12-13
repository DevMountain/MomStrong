//
//  MegsMessageViewController.swift
//  MomStrong
//
//  Created by DevMountain on 12/10/18.
//  Copyright © 2018 trevorAdcock. All rights reserved.
//

import UIKit

class MegsMessageViewController: UIViewController {
    
    @IBOutlet weak var megsMessageTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        megsMessageTextView.layer.masksToBounds = false
        megsMessageTextView.addShadow()
        setNavHeaderView()
        customizeBackButton()
        
        NotificationScheduler.shared.fetchMegsCurrentMessage { (message) in
            DispatchQueue.main.async {
                self.megsMessageTextView.text = message
            }
        }
    }
}
