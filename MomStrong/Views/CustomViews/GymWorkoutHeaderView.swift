//
//  GymWorkoutHeaderView.swift
//  MomStrong
//
//  Created by DevMountain on 12/19/18.
//  Copyright © 2018 trevorAdcock. All rights reserved.
//

import UIKit

class GymWorkoutHeaderView: UIView {

    @IBOutlet var stackView: UIStackView!
    @IBOutlet weak var workoutTitleLabel: CustomLabel!
    @IBOutlet weak var workoutTypeLabel: CustomLabel!
    
    override var intrinsicContentSize: CGSize{
        return CGSize(width: UIView.noIntrinsicMetric, height: workoutTitleLabel.intrinsicContentSize.height + workoutTypeLabel.intrinsicContentSize.height)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    convenience init(with workout: Workout){
        self.init()
        commonInit()
        workoutTitleLabel.text = workout.title
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit(){
        Bundle.main.loadNibNamed("GymWorkoutHeader", owner: self, options: nil)
        self.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        stackView.frame = self.bounds
        stackView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
}
