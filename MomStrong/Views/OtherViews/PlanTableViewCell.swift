//
//  PlanTableViewCell.swift
//  MomStrong
//
//  Created by DevMountain on 12/18/18.
//  Copyright © 2018 trevorAdcock. All rights reserved.
//

import UIKit

class PlanTableViewCell: UITableViewCell {

    @IBOutlet weak var planDescriptionLabel: UILabel!
    @IBOutlet weak var planNameLabel: UILabel!
    @IBOutlet weak var isSubscribedImageView: UIImageView!
    
    func updateViews(with plan: Plan, isSubscribed: Bool){
        planNameLabel.text = plan.title
        if plan.title == "At Home + Gym Plan"{
            let attributedText = NSMutableAttributedString(attributedString: NSAttributedString(string: "(Best Value!) - ", attributes: [NSAttributedString.Key.foregroundColor : UIColor.powerMomRed]))
            attributedText.append(NSAttributedString(string: plan.description))
            planDescriptionLabel.attributedText = attributedText
        }else {
            planDescriptionLabel.text = plan.description
        }
//        let planImage = isSubscribed ? #imageLiteral(resourceName: "SubscribedButton") : #imageLiteral(resourceName: "UpgradeButton")
//        isSubscribedImageView.image = planImage
        isSubscribedImageView.isHidden = !isSubscribed
    }
}
