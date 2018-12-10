//
//  CalendarCollectionViewCell.swift
//  MomStrong
//
//  Created by DevMountain on 11/25/18.
//  Copyright © 2018 trevorAdcock. All rights reserved.
//

import UIKit

class CalendarCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var isCompleteImage: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    
    var didComplete: Bool?{
        didSet{
            updateViews()
        }
    }
    
    func updateViews(){
        //TODO: place isCompleteImages in
        
    }
    
}

