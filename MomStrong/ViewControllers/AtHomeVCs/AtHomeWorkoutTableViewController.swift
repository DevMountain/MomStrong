//
//  AtHomeWorkoutTableViewController.swift
//  MomStrong
//
//  Created by DevMountain on 11/15/18.
//  Copyright © 2018 trevorAdcock. All rights reserved.
//

import UIKit

class AtHomeWorkoutTableViewController: UITableViewController {
    
    @IBOutlet weak var progressHeaderView: ProgressHeaderView!
    
    
    var workouts: [Workout]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpRootViewNavBar()
        
        WorkoutController.shared.fetchWorkouts(type: .atHome) { (workouts) in
            self.workouts = workouts
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.updateProgressHeader()
            }
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workouts?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "atHomeCell", for: indexPath) as? AtHomeWorkoutTableViewCell
        let workout = workouts?[indexPath.row]
        cell?.workout = workout
        cell?.delegate = self
        cell?.workoutNumberLabel.text = "Workout \(indexPath.row + 1)"
        return cell ?? UITableViewCell()
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as? AtHomeWorkoutDetailTableViewController
        guard let indexPath = tableView.indexPathForSelectedRow else {return}
        let workout = workouts?[indexPath.row]
        destinationVC?.workout = workout
    }
    
    func updateProgressHeader(){
        guard let workouts = workouts else { return }
        let filtered = ProgressController.shared.filterWorkoutsForCurrentWeek(workouts: workouts)
        let completed = ProgressController.shared.filterCompletedWorkouts(workouts: filtered)
        progressHeaderView.progress = Float(completed.count)/2.0
        progressHeaderView.workoutType = "At Home Workouts"
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        guard let indexPath = tableView.indexPathForSelectedRow else { return true }
        let cell = tableView.cellForRow(at: indexPath) as? AtHomeWorkoutTableViewCell
        return !(cell?.isLoading ?? false)
    }
}


extension AtHomeWorkoutTableViewController: AtHomeWorkoutTableViewCellDelegate{
    
    func toggleIsCompleted(sender: AtHomeWorkoutTableViewCell) {
        guard let workout = sender.workout else { return }
        ProgressController.shared.toggleIsCompleted(for: workout)
        updateProgressHeader()
    }
    
    func playButtonTapped(sender: AtHomeWorkoutTableViewCell) {
        let indexPath = tableView.indexPath(for: sender)
        tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        performSegue(withIdentifier: "toDetailVC", sender: self)
    }
    
    func calculateWeeklyProgress() -> Float?{
        guard let workouts = workouts,
            let currentUser = UserController.shared.currentUser else { return nil }
        let completedWorkouts = workouts.filter{ currentUser.hasCompleted(workout: $0) == true}
        return Float(completedWorkouts.count)/Float(workouts.count)
    }
}




//    func initMockData() -> [Workout]{
//        
//        let superCrunch = Exercise.init(title: "Super Crunch", description: "Grab that yoga ball and do a crap ton of crunches", id: UUID().uuidString, videoUrl: "Fakeurl.com", videoThumbnail: "OtherFakeUrl.com")
//        let pushUp = Exercise.init(title: "Push Up", description: "Just Push up on the ground", id: "String", videoUrl: nil, videoThumbnail: nil)
//        let superCrunchSet = SetGroup.init(exercise: superCrunch, sets: [12,12,10,10])
//        let pushUpSet = SetGroup.init(exercise: pushUp, sets: [20,20,20,20])
//        
//        let warmUp = Circuit.init(title: "Warm Up", description: "Bend over yoga ball and do a crunch", setGroups: [superCrunchSet, superCrunchSet, superCrunchSet])
//        
//        let circuit1 = Circuit.init(title: "Circuit 1", description: "Time to really engage that core.  Lets get it!", setGroups: [superCrunchSet, superCrunchSet, superCrunchSet])
//        
//        let circuit2 = Circuit.init(title: "Circuit 2", description: "Friends don't let friends skip leg day", setGroups: [superCrunchSet, superCrunchSet, superCrunchSet])
//        
//        let circuit3 = Circuit.init(title: "Circuit 3", description: """
//            
//            Yes this is possible however not a recommended way to implement. If you want to show replies below to each post along with the comment I would recommend you to implement through sections. Each section should have three types of cell as mentioned below:
//            
//            PostCellView
//            ReplyCellView
//            CommentCellView
//            
//            In this case number of section would be number of posts and total number of rows for each section would be 1(Post) + N(where N is total number of replies) + 1(Comment).
//            
//            With this approach you can add/remove replies through animation that Apple provides which is easy to implement.
//            
//            I hope this will help you, please feel free to ask if you have any concerns.
//""", setGroups: [superCrunchSet, pushUpSet, superCrunchSet, pushUpSet, superCrunchSet, pushUpSet])
//        
//        let workout1 = Workout.init(title: "Butt Burner", description: "This one is going to get those glutes going.  Get out there and get fit!", videoUrl: "https://fakeurl.com", type: .athome, circuits: [warmUp, circuit1, circuit2, circuit3], id: 2, duration: 19, equipmentNeeded: ["Yoga Ball", "Dumbells", "Bench"], thumbnailUrl: "fakeUrl.com")
//        
//        let workout2 = Workout.init(title: "Calf Catastophe", description: "This one is going to get those glutes going.  Get out there and get fit!", videoUrl: "https://fakeurl.com", type: .athome, circuits: [warmUp, circuit1, circuit2], id: 2, duration: 19, equipmentNeeded: ["Yoga Ball", "Dumbells", "Bench"], thumbnailUrl: "FakeUrl.com")
//        
//        return [workout1, workout2]
//    }
//}
