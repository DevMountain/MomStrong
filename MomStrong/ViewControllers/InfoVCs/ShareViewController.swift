//
//  ShareViewController.swift
//  MomStrong
//
//  Created by DevMountain on 12/13/18.
//  Copyright © 2018 trevorAdcock. All rights reserved.
//

import UIKit
import MessageUI

class ShareViewController: UIViewController, MFMessageComposeViewControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
         customizeBackButton()
    }

    public func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
    }
    
//    func presentTextMessageVC(){
//        let composeVC = MFMessageComposeViewController()
//        composeVC.messageComposeDelegate = self
//        
//        // Configure the fields of the interface.
//        composeVC.recipients = nil
//        composeVC.body = "Hey, I just found this App called Momstrong!  It helps me workout every week, and the videos are great.  Here is the link if you want to give it a try (: https://www.momstrongutah.com "
//        
//        // Present the view controller modally.
//        if MFMessageComposeViewController.canSendText() {
//            self.present(composeVC, animated: true, completion: nil)
//        }
//    }

    @IBAction func shareButtonTapped(_ sender: Any) {
        let promoString =
        """
        Hey, I just found this app called Momstrong Move! It gives me new workouts each week and the videos are great.  Here is the link if you want to give it a try ☺️
        https://www.momstrongutah.com
        """
        let activityViewController = UIActivityViewController(activityItems: [promoString], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true)
    }
}
