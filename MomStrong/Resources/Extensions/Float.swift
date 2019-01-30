//
//  Float.swift
//  MomStrong
//
//  Created by DevMountain on 11/30/18.
//  Copyright © 2018 trevorAdcock. All rights reserved.
//

import Foundation

extension Float{
    
    var asPercentString: String{
        guard !(self.isNaN || self.isInfinite) else { return "0%" }
        var percent = Int(self * 100)
        if percent > 100 { percent = 100 }
        return "\(percent)%"
    }
}
