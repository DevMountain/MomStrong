//
//  WorkoutProgressPoint.swift
//  MomStrong
//
//  Created by DevMountain on 11/28/18.
//  Copyright © 2018 trevorAdcock. All rights reserved.
//

import Foundation

extension WorkoutProgressPoint{
    
    convenience init(dateCompleted: Date = Date(), workoutId: Int, progress: Progress? = UserController.shared.currentUser?.progress){
        self.init(context: CoreDataStack.context)
        self.dateCompleted = dateCompleted
        self.workoutId = Int64(workoutId)
        self.progress = progress
    }
}
