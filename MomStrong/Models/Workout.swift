//
//  Workout.swift
//  MomStrong
//
//  Created by DevMountain on 12/3/18.
//  Copyright © 2018 trevorAdcock. All rights reserved.
//

import UIKit

class Workout{
    
    //Properties From Our Hosted Server
    let title: String
    let description: String
    let type: WorkoutType
    let circuits: [Circuit]
    let id: Int
    let vimeoId: Int = 303939659
    let equipmentNeeded: [String]?
    
    //Properties from Vimeo
    var duration: Int?
    var thumbnailUrl: String?
    var thumbnail: UIImage?
    var videoUrl: String?
    
    init(workoutService: WorkoutService) {
        self.title = workoutService.title
        self.description = workoutService.description
        self.type = workoutService.type
        self.circuits = workoutService.circuits
        self.id = workoutService.id
//        self.vimeoId = workoutService.vimeoId
        self.equipmentNeeded = workoutService.equipmentNeeded
    }
    
    func setVideoProperties(videoInfo: VimeoInfoObject, completion: @escaping () -> ()){
        self.duration = videoInfo.duration
        self.thumbnailUrl = videoInfo.pictures.sizes.last?.link
        if videoInfo.files.count >= 2{
            self.videoUrl = videoInfo.files[1].link
        }
        fetchThumbNail(completion: completion)
    }
    
    func fetchThumbNail(completion: @escaping () -> ()){
        guard let thumbnailUrl = self.thumbnailUrl else { completion() ; return }
        VimeoClient.fetchThumbnail(url: thumbnailUrl) { (image) in
            self.thumbnail = image
            completion()
        }
    }
}

