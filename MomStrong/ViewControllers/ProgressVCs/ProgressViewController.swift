//
//  ProgressViewController.swift
//  MomStrong
//
//  Created by DevMountain on 11/25/18.
//  Copyright © 2018 trevorAdcock. All rights reserved.
//

import UIKit

class ProgressViewController: UIViewController, SegmentProgressViewControllerDelegate {
    
    @IBOutlet weak var numberCompletedLabel: UILabel!
    @IBOutlet weak var timeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var completedLabel: UILabel!
    @IBOutlet weak var weekContainerView: UIView!
    @IBOutlet weak var monthContainerView: UIView!
    @IBOutlet weak var yearContainerView: UIView!
    @IBOutlet weak var progressHeaderView: ProgressHeaderView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpRootViewNavBar()
        setUpUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        swithTimeProgressViews()
    }

    @IBAction func timeSegmentValueChanged(_ sender: Any) {
        swithTimeProgressViews()
    }
    
    func swithTimeProgressViews(){
        switch timeSegmentedControl.selectedSegmentIndex{
        case 0: showWeekContainerView()
        case 1: showMonthContainerView()
        case 2: showYearContainerView()
        default:
            showWeekContainerView()
        }
    }
    
    func showWeekContainerView(){
        weekContainerView.isHidden = false
        monthContainerView.isHidden = true
        yearContainerView.isHidden = true
        setProgressView(for: .Week)
    }
    
    func showMonthContainerView(){
        weekContainerView.isHidden = true
        monthContainerView.isHidden = false
        yearContainerView.isHidden = true
        setProgressView(for: .Month)
    }
    
    func showYearContainerView(){
        weekContainerView.isHidden = true
        monthContainerView.isHidden = true
        yearContainerView.isHidden = false
        setProgressView(for: .Year)
    }
    
    func setProgressView(for timePeriod: TimePeriod){
        progressHeaderView.progress = ProgressController.shared.getCurrentPercentageOfProgress(for: timePeriod)
        let possible = UserController.shared.currentUser?.numberOfAvailableWorkouts(for: timePeriod)
        let completed = ProgressController.shared.numberOfCompletedWorkouts(for: timePeriod)
        numberCompletedLabel.text = "\(completed) of \(possible ?? 0) Completed"
    }
    
    func updateProgressView(){
        guard let timePeriod = TimePeriod(rawValue: timeSegmentedControl.selectedSegmentIndex) else {return}
        setProgressView(for: timePeriod)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toWeekContainerView"{
            let destination = segue.destination as? WeekProgressViewController
            destination?.delegate = self
        }
    }
    
    func setUpUI(){
        timeSegmentedControl.addShadow()
        timeSegmentedControl.layer.masksToBounds = true
//        timeSegmentedControl.layer.cornerRadius = 0
        
        timeSegmentedControl.layer.borderWidth = 0
        timeSegmentedControl.backgroundColor = .white
        timeSegmentedControl.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.lightGray
            ], for: .normal)
        
        progressHeaderView.titleImageView.isHidden = true
        progressHeaderView.layoutIfNeeded()
    }
}
