//
//  User.swift
//  MomStrong
//
//  Created by DevMountain on 11/13/18.
//  Copyright © 2018 trevorAdcock. All rights reserved.
//

import Foundation

class User{
    
    var firstName: String
    var lastName: String
    var dob: Date?
    var location: String?
    var id: Int
    var progress: Progress
    var subscription: Subscription
    var accountCreationDate: Date?
    
    var fullName: String{
        return "\(firstName) \(lastName)"
    }
    
    var age: Int?{
        guard let dob = dob else {return nil}
        let yearComponent = Calendar.current.dateComponents([.year], from: dob, to: Date())
        return yearComponent.year
    }
    
    init(firstName: String, lastName: String, dob: Date?, location: String?, subscription: Subscription, id: Int, progress: Progress? = nil) {
        self.firstName = firstName
        self.lastName = lastName
        self.dob = dob
        self.location = location
        self.subscription = subscription
        self.id = id
        if let progress = progress{
            self.progress = progress
        }else {
            self.progress = Progress(userID: id)
        }
    }
    
    convenience init(userService: UserService, progress: Progress?){
        self.init(firstName: userService.name, lastName: "Last Name", dob: nil, location: nil, subscription: Subscription(rawValue: userService.subscription) ?? .None, id: userService.id, progress: progress)
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
