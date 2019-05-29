//
//  StyleGuide.swift
//  MomStrong
//
//  Created by DevMountain on 11/30/18.
//  Copyright © 2018 trevorAdcock. All rights reserved.
//

import UIKit

extension UIColor{
    
    static var powerMomRed = UIColor(red: 252/255, green: 87/255, blue: 87/255, alpha: 1)
    
    static var backgroudGray = UIColor(red: 243/255, green: 244/255, blue: 244/255, alpha: 1)

    static var softBlack = UIColor(named: "softBlack")
}


extension UIView{
    
    func addShadow(offset: CGSize = CGSize(width: 0, height: 2), radius: CGFloat = 1.5, opacity: Float = 0.3){
        self.layer.shadowOffset = offset
        self.layer.shadowRadius = radius
        self.layer.shadowOpacity = opacity
    }
}
