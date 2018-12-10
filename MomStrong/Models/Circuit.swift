//
//  Circuit.swift
//  MomStrong
//
//  Created by DevMountain on 11/26/18.
//  Copyright © 2018 trevorAdcock. All rights reserved.
//

import Foundation

struct Circuit: Decodable{
    var title: String
    var description: String
    var excercises: [Exercise]
}
