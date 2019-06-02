//
//  MarkAsCompleteView.swift
//  MomStrong
//
//  Created by DevMountain on 12/20/18.
//  Copyright © 2018 trevorAdcock. All rights reserved.
//

import UIKit

protocol MarkAsCompleteViewDelegate: class{
    func markAsCompletedButtonTapped(sender: MarkAsCompleteView)
    func doItAgainButtonTapped(sender: MarkAsCompleteView)
}

class MarkAsCompleteView: UIView {

    @IBOutlet weak var completedButton: UIButton!
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var doItAgainButton : UIButton!
    @IBOutlet weak var completionCountLabel
    : UILabel!
    
    weak var delegate: MarkAsCompleteViewDelegate?
    
    
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
            self.doItAgainButton.isHidden = false
            self.completionCountLabel.isHidden = false
            self.updateCompletionCount()
            self.contentView.backgroundColor = UIColor.powerMomRed
            self.invalidateIntrinsicContentSize()
        }
    }
    
    func markWorkoutIncomplete(){
        UIView.animate(withDuration: 0.2) {
            self.completedButton.setImage(#imageLiteral(resourceName: "MarkAsComplete"), for: .normal)
            self.contentView.backgroundColor = UIColor.backgroudGray
            self.doItAgainButton.isHidden = true
            self.completionCountLabel.isHidden = true
            self.invalidateIntrinsicContentSize()
        }
    }
    
    func updateCompletionCount() {
        guard let workout = workout else { return }
        let completionCount = ProgressController.shared.completionCount(workout: workout)
        completionCountLabel.text = "\(completionCount)"
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
    
    @IBAction func doItAgainButtonTapped(_ sender: Any) {
        updateCompletionCount()
    }
}
