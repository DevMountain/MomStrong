//
//  DateCalendarCell.swift
//  MomStrong
//
//  Created by DevMountain on 5/29/19.
//  Copyright © 2019 trevorAdcock. All rights reserved.
//

import UIKit
import JTAppleCalendar

class DateCalendarCell: JTAppleCell {
    
    @IBOutlet weak var checkImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var backGroundView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backGroundView.addShadow(offset: CGSize(width: 0, height: 1))
    }
}
