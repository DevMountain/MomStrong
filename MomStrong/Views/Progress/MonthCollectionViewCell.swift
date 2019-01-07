//
//  MonthCollectionViewCell.swift
//  MomStrong
//
//  Created by DevMountain on 11/25/18.
//  Copyright © 2018 trevorAdcock. All rights reserved.
//

import UIKit

class MonthCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var percentCompleteLabel: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        adjustMonthLabelFontSize()
    }
    
    func adjustMonthLabelFontSize(){
        let size = self.frame.width / 7.0
        monthLabel.font = UIFont(name: "Poppins-Regular", size: size)
    }
}
