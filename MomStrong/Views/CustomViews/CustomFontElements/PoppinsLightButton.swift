//
//  PoppinsLightButton.swift
//  MomStrong
//
//  Created by DevMountain on 12/21/18.
//  Copyright © 2018 trevorAdcock. All rights reserved.
//

import UIKit

class PoppinsLightButton: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.updateFontTo(fontName: "Poppins-Light")
    }
    
    func updateFontTo(fontName: String){
        guard let size = self.titleLabel?.font.pointSize else { return }
        self.titleLabel?.font = UIFont(name: fontName, size: size)
    }
    
}
