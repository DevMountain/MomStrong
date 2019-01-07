//
//  WeekSeparatable.swift
//  MomStrong
//
//  Created by DevMountain on 1/3/19.
//  Copyright © 2019 trevorAdcock. All rights reserved.
//

import UIKit

protocol WeekSeparatable{
    var workouts: [Workout] { get set }
}

extension WeekSeparatable{
    
    var weeks: [[Workout]]{
        var weekArray: [Workout] = []
        var returnArray: [[Workout]] = []
        for (index, workout) in workouts.enumerated(){
            weekArray.append(workout)
            if weekArray.count >= 2 || index == workouts.count - 1{
                let week = weekArray
                returnArray.append(week)
                weekArray = []
            }
        }
        return returnArray
    }
}
