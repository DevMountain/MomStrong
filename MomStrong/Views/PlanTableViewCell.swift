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
        planDescriptionLabel.text = plan.description
        isSubscribedImageView.isHidden = !isSubscribed
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
