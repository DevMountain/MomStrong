//
//  Button+Extension.swift
//  MomStrong
//
//  Created by DevMountain on 12/13/18.
//  Copyright © 2018 trevorAdcock. All rights reserved.
//

import UIKit

extension UIButton{
    
    func stylize(){
        self.layer.cornerRadius = 4
        self.layer.borderColor = UIColor.powerMomRed.cgColor
        self.tintColor = .powerMomRed
        self.layer.borderWidth = 1.5
    }
}
