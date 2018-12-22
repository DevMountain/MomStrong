//
//  WorkoutSectionTableViewCell.swift
//  MomStrong
//
//  Created by DevMountain on 11/19/18.
//  Copyright © 2018 trevorAdcock. All rights reserved.
//

import UIKit

class WorkoutSectionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var sectionTitleLabel: UILabel!
    @IBOutlet weak var sectionDescriptionLabel: UILabel!
    @IBOutlet weak var separatorView: UIView!
    
    var workoutSection: Circuit?{
        didSet{
            updateViews()
        }
    }

    func updateViews(){
        sectionTitleLabel.text = workoutSection?.title
        sectionDescriptionLabel.text = workoutSection?.description
    }
}
