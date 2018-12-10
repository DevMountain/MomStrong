//
//  WorkoutSectionHeaderView.swift
//  MomStrong
//
//  Created by DevMountain on 11/23/18.
//  Copyright © 2018 trevorAdcock. All rights reserved.
//

import UIKit

class WorkoutSectionHeaderTableViewCell: UITableViewCell {
  
    @IBOutlet weak var sectionTitleLabel: UILabel!
    @IBOutlet weak var sectionDescriptionLabel: UILabel!
    
    
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
