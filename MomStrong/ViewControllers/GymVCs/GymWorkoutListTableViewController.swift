//
//  GymWorkoutListTableViewController.swift
//  MomStrong
//
//  Created by DevMountain on 12/19/18.
//  Copyright © 2018 trevorAdcock. All rights reserved.
//

import UIKit

class GymWorkoutListTableViewController: UITableViewController, WeekSeparatable {
    
    @IBOutlet weak var progressView: ProgressHeaderView!
    var workouts: [Workout] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpRootViewNavBar()
        let spinner = UIView.displaySpinner(onView: self.view)
        WorkoutController.shared.fetchWorkouts(type: .gymRat) { (workouts) in
            self.workouts = workouts ?? []
            DispatchQueue.main.async {
                UIView.removeSpinner(spinner: spinner)
                guard let workouts = workouts else { return }
                self.workouts = workouts
                self.tableView.reloadData()
                self.updateProgressView()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
        self.tableView.reloadData()
        self.updateProgressView()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return weeks.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weeks[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "gymWorkoutCell", for: indexPath) as!GymRatWorkoutTableViewCell
        let workout = weeks[indexPath.section][indexPath.row]
        cell.delegate = self
        cell.workout = workout
        return cell
    }
    
    
    //MARK: - Table View Delegate
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var text: String = ""
        switch section {
        case 0:
            text = "This Week's Workouts"
        case 1:
            text = "Last Week's Workouts"
        case 2:
            text = "Two Weeks Ago"
        default:
            text = "\(section) Week's Ago"
        }
        return text
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView, let textLabel = header.textLabel else { return }
        textLabel.textColor = UIColor.softBlack
        textLabel.font = UIFont(name: "Poppins-Light", size: 18)
        textLabel.frame = header.frame
        header.backgroundColor = UIColor.backgroudGray
        header.backgroundView?.backgroundColor = UIColor.backgroudGray
        
        let underline = UIView(frame: CGRect(x:textLabel.frame.minX + 16, y: textLabel.frame.height - 2.0, width: textLabel.frame.width - 32 , height: 2.0))
        underline.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        header.addSubview(underline)
    }
    
    func updateProgressView(){
        guard let weeklyCompleted = weeks.first else { return }
        let completed = ProgressController.shared.filterCompletedWorkouts(workouts: weeklyCompleted)
        let percentage = Float(completed.count)/2.0
        progressView.workoutTitleLabel.text = "Gym Workouts"
        progressView.progress = percentage
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toWorkoutDetail"{
            let destination = segue.destination as! GymWorkoutDetailViewController
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let workout = weeks[indexPath.section][indexPath.row]
            destination.workout = workout
        }
    }
}

extension GymWorkoutListTableViewController: GymRatWorkoutTableViewCellDelegate{
    
    func toggleIsCompleted(sender: UITableViewCell) {
        guard let indexPath = tableView.indexPath(for: sender) else { return }
        let workout = weeks[indexPath.section][indexPath.row]
        ProgressController.shared.toggleIsCompleted(for: workout)
        updateProgressView()
    }
    
    func presentDetailView(sender: GymRatWorkoutTableViewCell) {
        guard let indexPath = tableView.indexPath(for: sender) else { return }
        tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        self.performSegue(withIdentifier: "toWorkoutDetail", sender: self)
    }
}
