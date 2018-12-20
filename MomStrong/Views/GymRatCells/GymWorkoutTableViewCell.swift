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
    
    func resizeTableView()
}

class GymWorkoutTableViewCell: UITableViewCell {
    
    @IBOutlet weak var workoutTitleLabel: UILabel!
    @IBOutlet weak var workoutSectionsTableView: SelfSizingTableView!
    @IBOutlet weak var completedButton: UIButton!
    @IBOutlet weak var completedBarView: UIView!
//    @IBOutlet weak var bgView: UIView!
    
    var workout: Workout?{
        didSet{
            workoutSectionsTableView.dataSource = self
            workoutSectionsTableView.delegate = self
            updateViews()
            updateIsCompletedButton()
        }
    }
    
    var headerHeights: [CGFloat] = []
    
    var isFirstRow: Bool = true
    
    weak var delegate: GymWorkoutTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpUI()
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
        updateIsCompletedButton()
    }
    
    func updateIsCompletedButton(){
        guard let currentUser = UserController.shared.currentUser,
            let workout = workout else { return }
        let isComplete = currentUser.hasCompleted(workout: workout)
        isComplete ? markWorkoutComplete() : markWorkoutIncomplete()
    }
    
    func markWorkoutComplete(){
        UIView.animate(withDuration: 0.2) {
            self.completedButton.setImage(#imageLiteral(resourceName: "IDidThis"), for: .normal)
            self.completedBarView.backgroundColor = UIColor.powerMomRed
        }
    }
    
    func markWorkoutIncomplete(){
        UIView.animate(withDuration: 0.2) {
            self.completedButton.setImage(#imageLiteral(resourceName: "MarkAsComplete"), for: .normal)
            self.completedBarView.backgroundColor = UIColor.backgroudGray
        }
    }
    
    func setUpUI(){
//        bgView.layer.masksToBounds = false
//        bgView.addShadow()
    }
    
}

extension GymWorkoutTableViewCell: UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return workout?.circuits.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let workout = workout else { return 0 }
        return (workout.circuits[section].excercises.count + 1)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            guard let workoutSection = workout?.circuits[indexPath.section] else {return UITableViewCell()}
            let header = tableView.dequeueReusableCell(withIdentifier: "workoutSectionCell") as! WorkoutSectionHeaderTableViewCell
            header.workoutSection = workoutSection
            if indexPath.section == 0{
                header.sectionDividerView.backgroundColor = .powerMomRed
            }
            return header
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "exerciseCell", for: indexPath) as? GymExerciseTableViewCell
            let workoutSection = workout?.circuits[indexPath.section]
            cell?.exercise = workoutSection?.excercises[indexPath.row - 1]
            cell?.delegate = delegate
            return cell ?? UITableViewCell()
        }
    }
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        guard let workoutSection = workout?.circuits[section] else {return nil}
//        let header = tableView.dequeueReusableCell(withIdentifier: "workoutSectionCell") as? WorkoutSectionHeaderTableViewCell
//        header?.workoutSection = workoutSection
//        if section == 0{
//            header?.sectionDividerView.backgroundColor = .powerMomRed
//        }
////        if let height = header?.intrinsicContentSize.height{
////            print(height)
////            headerHeights.append(height)
////        }
//        return header
//    }
//
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
//        return 100
//    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
//    }
    
    func isLastRow(for indexPath: IndexPath) -> Bool {
        guard let workoutSections = workout?.circuits else { return false }
        let circuit = workoutSections[indexPath.section]
        return (indexPath.section == workoutSections.count - 1) && (indexPath.row == circuit.excercises.count - 1)
    }
}
