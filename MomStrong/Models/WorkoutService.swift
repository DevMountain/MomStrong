//
//  AtHomeWorkout.swift
//  MomStrong
//
//  Created by DevMountain on 11/13/18.
//  Copyright © 2018 trevorAdcock. All rights reserved.
//

import Foundation

struct WorkoutService: Decodable{
    
    let title: String?
    let description: String?
    let videoUrl: String?
    let type: WorkoutType?
    let circuits: [Circuit]?
    let id: Int?
    let vimeoId: Int?
    
    //MARK: - Not in Web Endpoints
    let duration: String?
    let equipmentNeeded: String?
    
    enum CodingKeys: String, CodingKey{
        case title
        case description
        case videoUrl = "video_url"
        case type
        case circuits
        case id
        case vimeoId
        
        case duration
        case equipmentNeeded = "equipment"
    }
}

enum WorkoutType: String, Decodable{
    case atHome
    case gymRat
}
