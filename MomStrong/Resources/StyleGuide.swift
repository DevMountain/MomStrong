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

}


extension UIView{
    
    func addShadow(){
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowRadius = (3.0 / 2.0)
        self.layer.shadowOpacity = 0.3
//        let rect = bounds.insetBy(dx: 1, dy: 1)
//        self.layer.shadowPath = UIBezierPath(rect: rect).cgPath
    }
}
