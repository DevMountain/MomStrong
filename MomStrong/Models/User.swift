//
//  User.swift
//  MomStrong
//
//  Created by DevMountain on 11/13/18.
//  Copyright © 2018 trevorAdcock. All rights reserved.
//

import Foundation

class User{
    
    var name: String
    var state: String?
    var id: Int
    var email: String
    var progress: Progress
    var subscription: Subscription
    var accountCreationDate: Date?
    var age: Int?
    
    init(name: String, state: String?, age: Int?, subscription: Subscription, id: Int, email: String, progress: Progress? = nil) {
        self.name = name
        self.state = state
        self.subscription = subscription
        self.id = id
        self.email = email
        self.age = age
        if let progress = progress{
            self.progress = progress
        }else {
            self.progress = Progress(userID: id)
        }
    }
    
    convenience init(userService: UserService, progress: Progress?){
        self.init(name: userService.name, state: userService.state, age: userService.age ,subscription: Subscription(rawValue: userService.subscription ?? "None") ?? .None, id: userService.id, email: userService.email, progress: progress)
        self.accountCreationDate = Date(timeIntervalSinceNow: -60 * 60 * 24 * 30 * 5)
    }
    
    var availableWorkoutPerWeek: Int{
        switch subscription {
        case .Gymrat, .AtHome:
            return 2
        case .Both:
            return 4
        case .None:
            return 0
        }
    }
    
    func numberOfAvailableWorkouts(for timePeriod: TimePeriod) -> Int{
        let multiplier = self.multiplier(for: self.subscription)
        switch timePeriod {
        case .Week:
            return 2 * multiplier
        case .Month:
            return 4 * multiplier + 1
        case .Year:
            return 52 * multiplier
        }
    }
    
    func numberOfCompletedWorkouts(for timePeriod: TimePeriod){
//        let availableWorkouts =
//        let completedWorkouts = availableWorkouts
    }
    
    func hasCompleted(workout: Workout) -> Bool{
        return self.progress.progressPoints.contains { (progressPoint) -> Bool in
            return Int(progressPoint.workoutId) == workout.id
        }
    }
    
    private func multiplier(for subscription: Subscription) -> Int{
        switch subscription {
        case .Gymrat, .AtHome:
            return 2
        case .Both:
            return 4
        case .None:
            return 0
        }
    }
}

enum Subscription: String{
    case AtHome = "atHome"
    case Gymrat = "gymRat"
    case Both = "both"
    case None = "none"
}

enum TimePeriod: Int{
    case Week
    case Month
    case Year
}
