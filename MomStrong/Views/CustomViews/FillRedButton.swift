//
//  FillRedButton.swift
//  MomStrong
//
//  Created by DevMountain on 1/7/19.
//  Copyright © 2019 trevorAdcock. All rights reserved.
//

import UIKit

class FillRedButton: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.powerMomRed
        self.titleLabel?.font = UIFont(name: "Poppins-Regular", size: 16)
        self.setTitleColor(.white, for: .normal)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.height/2
    }

}
