//
//  GymWorkoutTableViewController.swift
//  MomStrong
//
//  Created by DevMountain on 11/19/18.
//  Copyright © 2018 trevorAdcock. All rights reserved.
//

import UIKit

class GymWorkoutTableViewController: UITableViewController {
    

    @IBOutlet weak var progressHeaderView: ProgressHeaderView!
    
    var workouts: [Workout]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpRootViewNavBar()
        WorkoutController.shared.fetchWorkouts(type: .gymRat) { (workouts) in
            self.workouts = workouts
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.updateProgressHeaderView()
            }
        }
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return workouts?.count ?? 0
    }

    func updateProgressHeaderView(){
        progressHeaderView.progress = calculateWeeklyProgress()
        progressHeaderView.workoutType = "GymRat Workouts"
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "gymWorkoutCell", for: indexPath) as? GymWorkoutTableViewCell
        let workout = workouts?[indexPath.row]
        cell?.delegate = self
        cell?.workout = workout
        
//        if indexPath.row == ((workouts?.count ?? 1) - 1){
//            self.tableView.invalidateIntrinsicContentSize()
//            self.tableView.layoutIfNeeded()
//        }
        
        return cell ?? UITableViewCell()
    }
    
    func calculateWeeklyProgress() -> Float?{
        guard let workouts = workouts,
            let currentUser = UserController.shared.currentUser else { return nil }
        let completedWorkouts = workouts.filter{ currentUser.hasCompleted(workout: $0) == true}
        return Float(completedWorkouts.count)/Float(workouts.count)
    }
    
    func resizeTableView(){
        self.tableView.invalidateIntrinsicContentSize()
        self.tableView.setNeedsLayout()
        self.tableView.layoutIfNeeded()
    }
    
    
//    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
//    }
    
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        let cell = tableView.cellForRow(at: indexPath)
//        return cell?.intrinsicContentSize.height ?? 2000
//    }
}


extension GymWorkoutTableViewController: GymWorkoutTableViewCellDelegate{
    
    func markAsCompleted(sender: GymWorkoutTableViewCell) {
        guard let workout = sender.workout else {return}
        ProgressController.shared.toggleIsCompleted(for: workout)
        updateProgressHeaderView()
    }
    
}



extension GymWorkoutTableViewController{
    
//    func initMockData() -> [Workout]{
//        
//        let superCrunch = Exercise.init(title: "Super Crunch", description: "Grab that yoga ball and do a crap ton of crunches", id: UUID().uuidString, videoUrl: "Fakeurl.com", videoThumbnail: "OtherFakeUrl.com")
//        
//        let superCrunchSet = SetGroup.init(exercise: superCrunch, sets: [12,12,10,10])
//        
//        let warmUp = Circuit.init(title: "Warm Up", description: "Bend over yoga ball and do a crunch", setGroups: [superCrunchSet, superCrunchSet, superCrunchSet])
//        
//        let circuit1 = Circuit.init(title: "Circuit 1", description: "Time to really engage that core.  Lets get it!", setGroups: [superCrunchSet, superCrunchSet, superCrunchSet])
//        
//        let circuit2 = Circuit.init(title: "Circuit 2", description: "Friends don't let friends skip leg day", setGroups: [superCrunchSet, superCrunchSet, superCrunchSet])
//        
//        let workout1 = Workout.init(title: "Butt Burner", description: "This one is going to get those glutes going.  Get out there and get fit!", videoUrl: "https://fakeurl.com", type: .gymrat, circuits: [warmUp, circuit1, circuit2, circuit1, circuit2], id: 33, duration: 19, equipmentNeeded: ["Yoga Ball", "Dumbells", "Bench"], thumbnailUrl: "fakeUrl.com")
//        
//        let workout2 = Workout.init(title: "Calf Catastophe", description: "This one is going to get those glutes going.  Get out there and get fit!", videoUrl: "https://fakeurl.com", type: .gymrat, circuits: [warmUp, circuit1, circuit2], id: 44, duration: 19, equipmentNeeded: ["Yoga Ball", "Dumbells", "Bench"], thumbnailUrl: "FakeUrl.com")
//        
//        return [workout1, workout2]
//    }
    
}
