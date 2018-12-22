//
//  CustomLabel.swift
//  MomStrong
//
//  Created by DevMountain on 12/18/18.
//  Copyright © 2018 trevorAdcock. All rights reserved.
//

import UIKit

class CustomLabel: UILabel {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.updateFontTo(fontName: "Poppins-Regular")
    }

    func updateFontTo(fontName: String){
        let size = self.font.pointSize
        self.font = UIFont(name: fontName, size: size)!
    }
    
    override var intrinsicContentSize: CGSize{
        return self.text == "" ? CGSize(width: 0, height: 0) : super.intrinsicContentSize
    }

    override var bounds: CGRect {
        didSet {
            if (bounds.size.width != oldValue.size.width) {
                self.setNeedsUpdateConstraints();
            }
        }
    }
    
    override func updateConstraints() {
        if(self.preferredMaxLayoutWidth != self.bounds.size.width) {
            self.preferredMaxLayoutWidth = self.bounds.size.width
        }
        super.updateConstraints()
    }
}
