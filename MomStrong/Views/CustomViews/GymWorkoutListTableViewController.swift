//
//  GymWorkoutListTableViewController.swift
//  MomStrong
//
//  Created by DevMountain on 12/19/18.
//  Copyright © 2018 trevorAdcock. All rights reserved.
//

import UIKit

class GymWorkoutListTableViewController: UITableViewController {
    
    var workouts: [Workout] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        WorkoutController.shared.fetchWorkouts(type: .gymRat) { (workouts) in
            guard let workouts = workouts else { return }
            self.workouts = workouts
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return workouts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "fooBar", for: indexPath) as!GymRatWorkoutTableViewCell
        let workout = workouts[indexPath.row]
        cell.workout = workout
        return cell
    }
}
