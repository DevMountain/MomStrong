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
}

class GymRatWorkoutTableViewCell: UITableViewCell {

    @IBOutlet weak var gymRatStackView: UIStackView!
    @IBOutlet weak var bgView: UIView!
    
    @IBOutlet weak var completedBarView: UIView!
    @IBOutlet weak var completedButton: UIButton!
    
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
        guard !isConstructed else  {return }
        guard let workout = workout else { return }
        let header = GymWorkoutHeaderView(with: workout)
        gymRatStackView.addArrangedSubview(header)
        
        for circuit in workout.circuits{
            
            
            
            let circuitHeader = CircuitHeaderView(with: circuit)
            gymRatStackView.addArrangedSubview(circuitHeader)
            if circuit == workout.circuits.first{ circuitHeader.separatorView.backgroundColor = .powerMomRed}
            for exercise in circuit.excercises{
                let vc = delegate as? UIViewController
                let cell = GymExerciseCell(with: exercise, viewController: vc)
                gymRatStackView.addArrangedSubview(cell)
            }
        }
        updateIsCompleted()
        isConstructed = true
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
    
    func renderUI(){
        bgView.addShadow()
    }
}
