//
//  GymWorkoutTableViewCell.swift
//  MomStrong
//
//  Created by DevMountain on 11/19/18.
//  Copyright © 2018 trevorAdcock. All rights reserved.
//

import UIKit
import AVKit

protocol GymWorkoutTableViewCellDelegate: class{
    
    func markAsCompleted(sender: GymWorkoutTableViewCell)
    
    func presentAVPlayerVC(with AVPlayer: AVPlayer)
    
}

class GymWorkoutTableViewCell: UITableViewCell {
    
    @IBOutlet weak var workoutTitleLabel: UILabel!
    @IBOutlet weak var workoutSectionsTableView: SelfSizingTableView!
    @IBOutlet weak var completedButton: UIButton!
    @IBOutlet weak var completedBarView: UIView!
    
    var workout: Workout?{
        didSet{
            workoutSectionsTableView.dataSource = self
            workoutSectionsTableView.delegate = self
            workoutSectionsTableView.rowHeight = UITableView.automaticDimension
            workoutSectionsTableView.estimatedRowHeight = 900
            updateViews()
            updateIsCompleted()
        }
    }
    
    weak var delegate: GymWorkoutTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        tableViewHeight.constant = workoutSectionsTableView.contentSize.height
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func updateViews(){
        workoutTitleLabel.text = workout?.title
        workoutSectionsTableView.reloadData()
    }
    
    @IBAction func completedButtonTapped(_ sender: Any) {
        delegate?.markAsCompleted(sender: self)
        updateIsCompleted()
    }
    
    func updateIsCompleted(){
        guard let currentUser = UserController.shared.currentUser,
            let workout = workout else { return }
        let isComplete = currentUser.hasCompleted(workout: workout)
        isComplete ? markWorkoutComplete() : markWorkoutIncomplete()
    }
    
    func markWorkoutComplete(){
        UIView.animate(withDuration: 0.2) {
            self.completedButton.setTitle("I Did This", for: .normal)
            self.completedBarView.backgroundColor = UIColor.powerMomRed
        }
    }
    
    func markWorkoutIncomplete(){
        UIView.animate(withDuration: 0.2) {
            self.completedButton.setTitle("Mark As Complete", for: .normal)
            self.completedBarView.backgroundColor = .gray
        }
    }
    
}

extension GymWorkoutTableViewCell: UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return workout?.circuits.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workout?.circuits[section].excercises.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "exerciseCell", for: indexPath) as? GymExerciseTableViewCell
        let workoutSection = workout?.circuits[indexPath.section]
        cell?.exercise = workoutSection?.excercises[indexPath.row]
        cell?.delegate = delegate
//        if indexPath.section == (workout?.workoutSections.count ?? 0 - 1) && indexPath.row == (workoutSection?.setGroups.count ?? 0 - 1){
//        }
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let workoutSection = workout?.circuits[section] else {return nil}
        let header = tableView.dequeueReusableCell(withIdentifier: "workoutSectionCell") as? WorkoutSectionHeaderTableViewCell
        header?.workoutSection = workoutSection
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 100
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
    
}
