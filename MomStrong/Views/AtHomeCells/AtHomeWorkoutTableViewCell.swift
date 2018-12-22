//
//  AtHomeWorkoutTableViewCell.swift
//  MomStrong
//
//  Created by DevMountain on 11/19/18.
//  Copyright © 2018 trevorAdcock. All rights reserved.
//

import UIKit

protocol AtHomeWorkoutTableViewCellDelegate: class {
    
    func playButtonTapped(sender: AtHomeWorkoutTableViewCell)
    
    func toggleIsCompleted(sender: AtHomeWorkoutTableViewCell)
    
}

class AtHomeWorkoutTableViewCell: UITableViewCell {
    
    @IBOutlet weak var workoutNumberLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var equipmentLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var completedButton: UIButton!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var completedBarView: UIView!
    
    @IBOutlet weak var bgView: UIView!
    
    var workout: Workout?{
        didSet{
            updateViews()
        }
    }
    
    var isLoading: Bool = false
    
    weak var delegate: AtHomeWorkoutTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        renderUI()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func updateViews(){
        guard let workout = workout else { return }
        titleLabel.text = workout.title
        descriptionLabel.text = workout.description
        let equipment = workout.equipmentNeeded ?? ["None"]
        equipmentLabel.text = "Equipment: " + equipment.joined(separator: " ")
        durationLabel.text = "Duration: \(workout.duration ?? "FUN")"
        updateIsCompleted()
        isLoading = true
        let spinner = UIView.displaySpinner(onView: self.contentView)
        WorkoutController.shared.fetchVimeoData(for: workout) { (workout) in
            DispatchQueue.main.async {
                self.isLoading = false
                UIView.removeSpinner(spinner: spinner)
                self.thumbnailImageView.image = workout?.thumbnail
            }
        }
    }
    
    func updateIsCompleted(){
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
    
    @IBAction func playButtonTapped(_ sender: Any) {
        delegate?.playButtonTapped(sender: self)
    }
    
    @IBAction func completedButtonTapped(_ sender: Any) {
        delegate?.toggleIsCompleted(sender: self)
        updateIsCompleted()
    }
    
    func renderUI(){
        bgView.addShadow()
    }
}
