//
//  WorkoutVideoInfo.swift
//  MomStrong
//
//  Created by DevMountain on 12/3/18.
//  Copyright © 2018 trevorAdcock. All rights reserved.
//

import Foundation

struct VimeoInfoObject: Codable{
    
    var name: String
    var description: String
    var pictures: VimeoPictures
    var files: [VimeoFile]
    var duration: Int
}

struct VimeoPictures: Codable{
    var sizes: [VimeoThumbnail]
}

struct VimeoThumbnail: Codable{
    var link: String
    var linkWithPlayButton: String
    
    enum CodingKeys: String, CodingKey {
        case link
        case linkWithPlayButton = "link_with_play_button"
    }
}

struct VimeoFile: Codable{
    var quality: String
    var link: String
    var size: Int
}
