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
        setUpKeyboardForGoalTextField()
        
    }
    
    func updateViews(){
        goalTextField.text = goal?.title
        updateCompletedButton()
    }
    
    func updateCompletedButton(){
        guard let goal = goal else { return }
        let buttonImage = goal.isCompleted ? #imageLiteral(resourceName: "CompletedGoal") : #imageLiteral(resourceName: "MarkDone_Empty")
        isCompletedButton.setImage(buttonImage, for: .normal)
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
    
    @objc func resignKeyboard(){
        goalTextField.resignFirstResponder()
    }
    
    func setUpKeyboardForGoalTextField(){
        let toolbar = UIToolbar()
        toolbar.setItems([UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(resignKeyboard))], animated: false)
        toolbar.tintColor = .powerMomRed
        toolbar.isUserInteractionEnabled = true
        toolbar.sizeToFit()
        goalTextField.inputAccessoryView = toolbar
        goalTextField.delegate = self
    }
}
