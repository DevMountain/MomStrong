//
//  GymWorkoutListTableViewController.swift
//  MomStrong
//
//  Created by DevMountain on 12/19/18.
//  Copyright © 2018 trevorAdcock. All rights reserved.
//

import UIKit

class GymWorkoutListTableViewController: UITableViewController {
    
    @IBOutlet weak var progressView: ProgressHeaderView!
    var workouts: [Workout] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpRootViewNavBar()
        WorkoutController.shared.fetchWorkouts(type: .gymRat) { (workouts) in
            guard let workouts = workouts else { return }
            self.workouts = workouts
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.updateProgressView()
            }
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return workouts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "gymWorkoutCell", for: indexPath) as!GymRatWorkoutTableViewCell
        let workout = workouts[indexPath.row]
        cell.delegate = self
        cell.workout = workout
        return cell
    }
    
    func updateProgressView(){
        let weeklyCompleted = ProgressController.shared.filterWorkoutsForCurrentWeek(workouts: workouts)
        let completed = ProgressController.shared.filterCompletedWorkouts(workouts: weeklyCompleted)
        let percentage = Float(completed.count)/2.0
        progressView.workoutTitleLabel.text = "Gym Workouts"
        progressView.progress = percentage
    }
}

extension GymWorkoutListTableViewController: GymRatWorkoutTableViewCellDelegate{
    
    func toggleIsCompleted(sender: UITableViewCell) {
        guard let indexPath = tableView.indexPath(for: sender) else { return }
        let workout = workouts[indexPath.row]
        ProgressController.shared.toggleIsCompleted(for: workout)
        updateProgressView()
    }
}
