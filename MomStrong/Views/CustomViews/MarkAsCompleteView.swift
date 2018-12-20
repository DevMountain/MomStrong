//
//  MarkAsCompleteView.swift
//  MomStrong
//
//  Created by DevMountain on 12/20/18.
//  Copyright © 2018 trevorAdcock. All rights reserved.
//

import UIKit

class MarkAsCompleteView: UIView {

    @IBOutlet weak var completedButton: UIButton!
    @IBOutlet var contentView: UIView!
    
    var workout: Workout?{
        didSet{
            updateIsCompleted()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 500, height: 48)
    }
    
    override func layoutSubviews() {
        contentView.center = self.center
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    convenience init(with workout: Workout?){
        self.init()
        self.workout = workout
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
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
            self.contentView.backgroundColor = UIColor.powerMomRed
            self.invalidateIntrinsicContentSize()
        }
    }
    
    func markWorkoutIncomplete(){
        UIView.animate(withDuration: 0.2) {
            self.completedButton.setImage(#imageLiteral(resourceName: "MarkAsComplete"), for: .normal)
            self.contentView.backgroundColor = UIColor.backgroudGray
            self.invalidateIntrinsicContentSize()
        }
    }
    
    private func commonInit(){
        Bundle.main.loadNibNamed("MarkAsCompleteView", owner: self, options: nil)
        self.translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 1000), for: .vertical)
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        invalidateIntrinsicContentSize()
    }

    @IBAction func completedButtonTapped(_ sender: Any) {
        guard let workout = workout else { return }
        ProgressController.shared.toggleIsCompleted(for: workout)
        updateIsCompleted()
    }
}
