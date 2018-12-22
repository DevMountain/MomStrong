//
//  CustomButton.swift
//  MomStrong
//
//  Created by DevMountain on 12/18/18.
//  Copyright © 2018 trevorAdcock. All rights reserved.
//

import UIKit

class CustomButton: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.updateFontTo(fontName: "Poppins-Regular")
    }
    
    func updateFontTo(fontName: String){
        guard let size = self.titleLabel?.font.pointSize else { return }
        self.titleLabel?.font = UIFont(name: fontName, size: size)
    }

}

