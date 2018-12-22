//
//  FollowViewController.swift
//  MomStrong
//
//  Created by DevMountain on 12/13/18.r
//  Copyright © 2018 trevorAdcock. All rights reserved.
//

import UIKit

class FollowViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func instagramButtonTapped(_ sender: Any) {
        guard let instagramAppUrl = URL(string: "instagram://user?username=momstrongutah") else { return }
        if UIApplication.shared.canOpenURL(instagramAppUrl) {
            UIApplication.shared.open(instagramAppUrl, options: [:], completionHandler: nil)
        } else {
            //redirect to safari because the user doesn't have Instagram
            guard let instagramWebUrl = URL(string: "https://instagram.com/momstrongutah") else { return }
            UIApplication.shared.open(instagramWebUrl, options: [:], completionHandler: nil)
        }
    }
    
    @IBAction func blogButtonTapped(_ sender: Any) {
        guard let blogUrl = URL(string: "https://momstrongutah.com") else { return }
        UIApplication.shared.open(blogUrl, options: [:], completionHandler: nil)
    }
    
    @IBAction func momstrongmoveButtonTapped(_ sender: Any) {
        guard let msmUrl = URL(string: "https://momstrongmove.com") else { return }
        UIApplication.shared.open(msmUrl, options: [:], completionHandler: nil)
    }
}
