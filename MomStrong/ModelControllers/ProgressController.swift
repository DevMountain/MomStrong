//
//  ProgressController.swift
//  MomStrong
//
//  Created by DevMountain on 11/26/18.
//  Copyright © 2018 trevorAdcock. All rights reserved.
//

import Foundation
import CoreData

class ProgressController{
    
    static let shared = ProgressController()
    
    func createNewGoal(for user: User? = UserController.shared.currentUser, title: String){
        let goal = Goal(title: title)
        user?.progress.goals.append(goal)
    }
    
    func update(goal: Goal, for user: User? = UserController.shared.currentUser, newtitle: String){
        guard let index = user?.progress.goals.index(of: goal) else { return }
        user?.progress.goals[index].title = newtitle
        CoreDataStack.save()
    }
    
    func delete(goal: Goal, for user: User? = UserController.shared.currentUser){
        guard let index = user?.progress.goals.index(of: goal) else { return }
        user?.progress.goals.remove(at: index)
        CoreDataStack.save()
    }
    
    func toggleIsCompleted(for workout: Workout){
        guard let currentUser = UserController.shared.currentUser else { return }
        //        let isCompleted = userProgress.progressPoints.contains(where: { (progressPoint) -> Bool in
        //            return workout.id == progressPoint.workoutId
        //        })
        let index = currentUser.progress.progressPoints.firstIndex(where: { $0.workoutId == workout.id })
        if let index = index{
            deleteProgressPoint(for: currentUser, index: index)
        }else{
            createProgressPoint(from: workout, for: currentUser)
        }
    }
    
    func deleteProgressPoint(for user: User, index: Int){
        user.progress.progressPoints.remove(at: index)
        CoreDataStack.save()
    }
    
    @discardableResult
    func createProgressPoint(from workout: Workout, for user: User) -> WorkoutProgressPoint?{
        let progressPoint = WorkoutProgressPoint(workoutId: workout.id)
        user.progress.progressPoints.append(progressPoint)
        CoreDataStack.save()
        return progressPoint
    }
    
    func fetchProgress(for userID: Int) -> Progress?{
        let userID64 = Int64(userID)
        let request: NSFetchRequest<Progress> = Progress.fetchRequest()
        request.predicate = NSPredicate(format: "%K = %d","userID", userID64)
        do{
            let progress = try CoreDataStack.context.fetch(request).first
            progress?.goals = progress?.goals.filter{ $0.timeStamp ?? Date(timeIntervalSince1970: 0) > CalendarHelper().oneWeekAgo} ?? []
            return progress
        } catch {
            print("There was as error in \(#function) :  \(error) \(error.localizedDescription)")
            return nil
        }
    }
    
    func getCurrentPercentageOfProgress(for timePeriod: TimePeriod, month: Int = Calendar.current.dateComponents([.day, .weekOfYear, .month, .year], from: Date()).month!) -> Float?{
        guard let currentUser = UserController.shared.currentUser else {return nil}
        switch timePeriod{
        case .Week:
            return completionPercentageForCurrentWeek()
        case .Month:
            return completionRateFor(month: month, user: currentUser)
        case .Year:
            return completionRateForCurrentYear(user: currentUser)
        }
    }
    
    func completedOutOfTotal(month: Int, user: User = UserController.shared.currentUser!) -> (completed: Int, available: Int){
        let completedWorkouts = filterProgressPointsFor(month: month, user: user)
        let available = user.numberOfAvailableWorkouts(for: .Month)
        return (completedWorkouts.count, available)
    }
    
    func completedOutOfTotalForCurrentWeek
        (user: User = UserController.shared.currentUser!) -> (completed: Int, total: Int){
        let totalWorkouts = user.availableWorkoutPerWeek
        let completedWorkouts = filterProgressPointsForCurrentWeek(user: user)
        return (completedWorkouts.count, totalWorkouts)
    }
    
    func completionPercentageForCurrentWeek() -> Float{
        let completedTuple = completedOutOfTotalForCurrentWeek()
        return Float(completedTuple.completed)/Float(completedTuple.total)
    }
    
    
    func completionRateFor(month: Int, user: User = UserController.shared.currentUser!) -> Float{
        let filteredWorkouts = filterProgressPointsFor(month: month, user: user)
        let availabeWorkouts = user.numberOfAvailableWorkouts(for: .Month)
        return Float(filteredWorkouts.count)/Float(availabeWorkouts)
    }
    
    func completionRateForCurrentYear(user: User = UserController.shared.currentUser!) -> Float{
        guard let accountCreationDate = user.accountCreationDate else {return 0}
        let dateComponentDifference = Calendar.current.dateComponents([.weekOfYear, .year], from: accountCreationDate, to: Date())
        let availabeWorkoutCount = user.availableWorkoutPerWeek * (dateComponentDifference.weekOfYear ?? 0)
        let completedWorkoutCount = user.progress.progressPoints.count
        return Float(completedWorkoutCount)/Float(availabeWorkoutCount)
    }
    
    func numberOfCompletedWorkouts(for timePeriod: TimePeriod, user: User? = UserController.shared.currentUser, month: Int? = CalendarHelper().dateComponentsNow.month) -> Int{
        guard let user = user else { return 0}
        switch timePeriod{
        case .Week:
            return user.progress.goals.count
        case .Month:
            guard let currentMonth = month else { return 0 }
            return filterProgressPointsFor(month: currentMonth, user: user).count
        case .Year:
            return user.progress.progressPoints.count
        }
    }
    
    func filterProgressPointsFor(month: Int, user: User) -> [WorkoutProgressPoint]{
        return user.progress.progressPoints.filter{
            if let dateCompleted = $0.dateCompleted{
                let workoutCompletedMonth = Calendar.current.component(.month, from: dateCompleted)
                return month == workoutCompletedMonth
            }else {
                return false
            }
        }
    }
    
    func filterProgressPointsForCurrentWeek(user: User) -> [WorkoutProgressPoint]{
        return user.progress.progressPoints.filter{
            if let dateCompleted = $0.dateCompleted{
                let workoutCompletedWeek = Calendar.current.component(.weekOfYear, from: dateCompleted)
                return workoutCompletedWeek == CalendarHelper().dateComponentsNow.weekOfYear
            }else {
                return false
            }
        }
    }
    
    func filterWorkoutsForCurrentWeek(user: User = UserController.shared.currentUser!, workouts: [Workout]) -> [Workout]{
        guard workouts.count > 1 else { return [] }
        let filtered = Array(workouts[0..<2])
        return filtered
    }
    
    func filterCompletedWorkouts(for user: User = UserController.shared.currentUser!, workouts: [Workout]) -> [Workout]{
        return workouts.filter{ user.hasCompleted(workout: $0) }
    }
}
