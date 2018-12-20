//
//  GymRatWorkoutTableViewCell.swift
//  MomStrong
//
//  Created by DevMountain on 12/19/18.
//  Copyright © 2018 trevorAdcock. All rights reserved.
//

import UIKit

class GymRatWorkoutTableViewCell: UITableViewCell {

    @IBOutlet weak var gymRatStackView: UIStackView!
    
    var workout: Workout?{
        didSet{
            updateViews()
        }
    }
    
    func updateViews(){
        guard let workout = workout else { return }
        let header = GymWorkoutHeaderView(with: workout)
        gymRatStackView.addArrangedSubview(header)
        
        for circuit in workout.circuits{
            
            let circuitHeader = CircuitHeaderView(with: circuit)
            gymRatStackView.addArrangedSubview(circuitHeader)
            
            for exercise in circuit.excercises{
                
                let cell = GymExerciseCell(with: exercise)
                gymRatStackView.addArrangedSubview(cell)
                
            }
        }
        gymRatStackView.setNeedsUpdateConstraints()
    }
}
