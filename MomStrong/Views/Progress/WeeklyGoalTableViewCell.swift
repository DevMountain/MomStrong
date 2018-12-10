//
//  WeeklyGoalTableViewCell.swift
//  MomStrong
//
//  Created by DevMountain on 11/25/18.
//  Copyright © 2018 trevorAdcock. All rights reserved.
//

import UIKit

protocol TextFieldCellDelegate: class {
    
    func textFieldShouldReturn(sender: WeeklyGoalTableViewCell)
    
    func completedButtonTapped(sender: WeeklyGoalTableViewCell)
}

class WeeklyGoalTableViewCell: UITableViewCell {

    @IBOutlet weak var goalTextField: UITextField!
    @IBOutlet weak var isCompletedButton: UIButton!
    
    var goal: Goal?{
        didSet{
            updateViews()
        }
    }
    
    weak var delegate: TextFieldCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        goalTextField.delegate = self
    }
    
    func updateViews(){
        goalTextField.text = goal?.title
        updateCompletedButton()
    }
    
    func updateCompletedButton(){
        guard let goal = goal else { return }
        let buttonText = goal.isCompleted ? "Done" : "Not Done"
        isCompletedButton.setTitle(buttonText, for: .normal)
    }
    
    @IBAction func completedButtonTapped(_ sender: Any) {
        delegate?.completedButtonTapped(sender: self)
        updateCompletedButton()
    }
}

extension WeeklyGoalTableViewCell: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        delegate?.textFieldShouldReturn(sender: self)
        textField.resignFirstResponder()
        return true
    }
}
