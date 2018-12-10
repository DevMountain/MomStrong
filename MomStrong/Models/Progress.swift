//
//  Progress.swift
//  MomStrong
//
//  Created by DevMountain on 11/25/18.
//  Copyright © 2018 trevorAdcock. All rights reserved.
//

import Foundation

extension Progress {

    
    convenience init(userID: Int, goals: [Goal] = [], progressPoints: [WorkoutProgressPoint] = []){
        self.init(context: CoreDataStack.context)
        self.userID = Int64(userID)
        self.goals = goals
        self.progressPoints = progressPoints
    }
    
    var goals: [Goal]{
        get{
            let defaultSet: NSOrderedSet = NSOrderedSet(arrayLiteral: [Goal]())
            return Array(self.goalSet ?? defaultSet) as? [Goal] ?? []
        }
        set{
            self.goalSet = NSOrderedSet(array: newValue)
            CoreDataStack.save()
        }
    }
    
    var progressPoints: [WorkoutProgressPoint]{
        get{
            let defaultSet: NSOrderedSet = NSOrderedSet(arrayLiteral: [WorkoutProgressPoint]())
            return Array(self.progressPointsSet ?? defaultSet) as? [WorkoutProgressPoint] ?? []
        }
        set{
            self.progressPointsSet = NSOrderedSet(array: newValue)
            CoreDataStack.save()
        }
    }
}

