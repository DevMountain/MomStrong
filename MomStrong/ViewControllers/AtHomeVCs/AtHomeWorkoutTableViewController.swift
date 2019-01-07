//
//  AtHomeWorkoutTableViewController.swift
//  MomStrong
//
//  Created by DevMountain on 11/15/18.
//  Copyright © 2018 trevorAdcock. All rights reserved.
//

import UIKit

class AtHomeWorkoutTableViewController: UITableViewController, WeekSeparatable {
    
    @IBOutlet weak var progressHeaderView: ProgressHeaderView!
    
    var workouts: [Workout] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpRootViewNavBar()
        
        WorkoutController.shared.fetchWorkouts(type: .atHome) { (workouts) in
            guard let workouts = workouts else { return }
            self.workouts = workouts
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.updateProgressHeader()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        self.updateProgressHeader()
    }

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return weeks.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weeks[section].count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "atHomeCell", for: indexPath) as? AtHomeWorkoutTableViewCell
        cell?.delegate = self
        let week = weeks[indexPath.section]
        let workout = week[indexPath.row]
        cell?.workout = workout
        cell?.workoutNumberLabel.text = "Workout \(indexPath.row + 1)"
        return cell ?? UITableViewCell()
    }
    
    //MARK: - Table View Delegate
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var text: String = ""
        switch section {
        case 0:
            text = "This Weeks Workouts"
        case 1:
            text = "Last Week Workouts"
        case 2:
            text = "Two Weeks Ago"
        default:
            text = "\(section) Weeks Ago"
        }
        return text
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView, let textLabel = header.textLabel else { return }
        textLabel.textColor = UIColor.softBlack
        textLabel.font = UIFont(name: "Poppins-Light", size: 18)!
        textLabel.frame = header.frame
        let underline = UIView(frame: CGRect(x:textLabel.frame.minX + 16, y: textLabel.frame.height - 2.0, width: textLabel.frame.width - 32 , height: 2.0))
        underline.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        header.addSubview(underline)

        header.backgroundView?.backgroundColor = UIColor.backgroudGray
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as? AtHomeWorkoutDetailTableViewController
        guard let indexPath = tableView.indexPathForSelectedRow else {return}
        let workout = weeks[indexPath.section][indexPath.row]
        destinationVC?.workout = workout
    }
    
    func updateProgressHeader(){
        guard let filtered = weeks.first else { return }
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
    
//    func calculateWeeklyProgress() -> Float?{
//        guard let workouts = workouts,
//            let currentUser = UserController.shared.currentUser else { return nil }
//        let completedWorkouts = workouts.filter{ currentUser.hasCompleted(workout: $0) == true}
//        return Float(completedWorkouts.count)/Float(workouts.count)
//    }
}
