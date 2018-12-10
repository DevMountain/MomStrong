//
//  Exercise.swift
//  MomStrong
//
//  Created by DevMountain on 11/13/18.
//  Copyright © 2018 trevorAdcock. All rights reserved.
//

import Foundation

struct Exercise: Codable{
    
    let title: String
    let description: String
    let id: Int
    //Video and videoUrl will only be on GymRat extercises
    var videoUrl: String?
    var thumbnailUrl: String?
    let vimeoId: Int = 303939659
}
