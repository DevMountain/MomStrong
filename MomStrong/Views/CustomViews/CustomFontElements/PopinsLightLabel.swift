//
//  PopinsLightLabel.swift
//  MomStrong
//
//  Created by DevMountain on 12/21/18.
//  Copyright © 2018 trevorAdcock. All rights reserved.
//

import Foundation

class PoppinsLightLabel: CustomLabel{
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.updateFontTo(fontName: "Poppins-Light")
    }
}
