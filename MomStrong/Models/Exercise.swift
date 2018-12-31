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
    var vimeoUrl: String?
    var thumbnailUrl: String?
    var videoUrl: String?
    
    enum CodingKeys: String, CodingKey{
        case title, description, id
        case vimeoUrl = "video_url"
        case thumbnailUrl
        case videoUrl
    }
    
    var vimeoId: Int?{
        guard let vimeoUrl = vimeoUrl else { return nil }
        return WorkoutController.shared.pullVimeoIdFrom(vimeoUrl: vimeoUrl)
    }
    
}
