//
//  GymRatWorkoutTableViewCell.swift
//  MomStrong
//
//  Created by DevMountain on 12/19/18.
//  Copyright © 2018 trevorAdcock. All rights reserved.
//

import UIKit

protocol GymRatWorkoutTableViewCellDelegate: class{
    func toggleIsCompleted(sender: UITableViewCell)
    func presentDetailView(sender: GymRatWorkoutTableViewCell)
}

class GymRatWorkoutTableViewCell: UITableViewCell {
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var completedBarView: UIView!
    @IBOutlet weak var completedButton: UIButton!
    @IBOutlet weak var workoutTitleLabel: UILabel!
    @IBOutlet weak var descriptionLabel : UILabel!
    
    var isConstructed: Bool = false
    
    weak var delegate: GymRatWorkoutTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bgView.addShadow()
    }
    
    var workout: Workout?{
        didSet{
            updateViews()
        }
    }
    
    func updateViews(){
        workoutTitleLabel.text = workout?.title
        descriptionLabel.text = workout?.description
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
    
    @IBAction func completedButtonTapped(_ sender: Any) {
        delegate?.toggleIsCompleted(sender: self)
        updateIsCompleted()
    }
    
    @IBAction func viewButtonTapped(_ sender: Any) {
        delegate?.presentDetailView(sender: self)
    }
    
    func renderUI(){
        bgView.addShadow()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        //        markWorkoutIncomplete()
    }
}
