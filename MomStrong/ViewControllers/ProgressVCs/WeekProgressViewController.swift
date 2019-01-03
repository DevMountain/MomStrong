//
//  WeekProgressViewController.swift
//  MomStrong
//
//  Created by DevMountain on 11/25/18.
//  Copyright © 2018 trevorAdcock. All rights reserved.
//

import UIKit

class WeekProgressViewController: UIViewController {
    
    @IBOutlet weak var goalsTableView: SelfSizingTableView!
    @IBOutlet weak var tableViewBGView: UIView!
    
    weak var delegate: SegmentProgressViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewBGView.addShadow()
        goalsTableView.dataSource = self
        goalsTableView.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        // Do any additional setup after loading the view.
    }
    
}

extension WeekProgressViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let goalCount = UserController.shared.currentUser?.progress.goals.count else {return 1}
        return goalCount + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let goals = UserController.shared.currentUser?.progress.goals else {return WeeklyGoalTableViewCell()}
        let cell = tableView.dequeueReusableCell(withIdentifier: "goalCell", for: indexPath) as? WeeklyGoalTableViewCell
        var goal: Goal?
        cell?.delegate = self
        if indexPath.row < goals.count{
            goal = UserController.shared.currentUser?.progress.goals[indexPath.row]
        }
        
        cell?.goal = goal
        return cell ?? WeeklyGoalTableViewCell()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        guard indexPath.row < UserController.shared.currentUser?.progress.goals.count ?? 0 else { return }
        
        if editingStyle == .delete{
            guard let goal = UserController.shared.currentUser?.progress.goals[indexPath.row] else { return }
            ProgressController.shared.delete(goal: goal)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

extension WeekProgressViewController: TextFieldCellDelegate{
    
    func completedButtonTapped(sender: WeeklyGoalTableViewCell) {
        sender.goal?.toggleIsCompleted()
    }
    
    
    func textFieldShouldReturn(sender: WeeklyGoalTableViewCell) {
        guard let title = sender.goalTextField.text else {return}
        ProgressController.shared.createNewGoal(title: title)
        goalsTableView.reloadData()
    }
    
}
