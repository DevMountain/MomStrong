//
//  GymWorkoutDetailViewController.swift
//  MomStrong
//
//  Created by DevMountain on 1/7/19.
//  Copyright © 2019 trevorAdcock. All rights reserved.
//

import UIKit

class GymWorkoutDetailViewController: UIViewController {
    
    @IBOutlet weak var workoutTitleLabel: CustomLabel!
    @IBOutlet weak var workoutCircuitTableView: UITableView!
    @IBOutlet weak var descriptionLabel : UILabel!
    
    var workout: Workout?{
        didSet{
            loadViewIfNeeded()
            updateViews()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        workoutCircuitTableView.dataSource = self
        customizeBackButton()
        setNavHeaderView()
    }
    
    func updateViews(){
        workoutTitleLabel.text = workout?.title
        descriptionLabel.text = workout?.description
        workoutCircuitTableView.reloadData()
    }
}

extension GymWorkoutDetailViewController: UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return workout?.circuits.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let workout = workout else { return 0 }
        return workout.circuits[section].excercises.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
        let cell = tableView.dequeueReusableCell(withIdentifier: "circuitCell", for: indexPath) as! CircuitHeaderTableViewCell
          let circuit = workout?.circuits[indexPath.section]
            if indexPath.section == 0{ cell.separatorView.backgroundColor = UIColor.powerMomRed }
            cell.circuit = circuit
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "exerciseCell", for: indexPath) as! GymExerciseTableViewCell
            let exercise = workout?.circuits[indexPath.section].excercises[indexPath.row - 1]
            cell.viewController = self
            cell.exercise = exercise
            return cell
        }
    }
}
