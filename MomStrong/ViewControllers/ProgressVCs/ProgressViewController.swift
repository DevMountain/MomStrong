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
    @IBOutlet weak var timeHorizonLabel: UILabel!
    @IBOutlet weak var headerLabelStackView: UIStackView!
    @IBOutlet weak var leftArrowButton: UIButton!
    @IBOutlet weak var rightArrowButton: UIButton!
    
    var selectedMonth: Int = CalendarHelper().currentMonth
    var monthProgressViewController: MonthProgressViewController?
    
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
        UIView.animate(withDuration: 0.2) {
            self.headerLabelStackView.isHidden = true
        }
        setProgressView(for: .Week)
    }
    
    func showMonthContainerView(){
        weekContainerView.isHidden = true
        monthContainerView.isHidden = false
        yearContainerView.isHidden = true
        UIView.animate(withDuration: 0.2) {
            self.headerLabelStackView.isHidden = false
            self.leftArrowButton.isHidden = false
            self.rightArrowButton.isHidden = false
            self.timeHorizonLabel.text = CalendarHelper().monthName(for: self.selectedMonth)
        }
        setProgressView(for: .Month)
    }
    
    func showYearContainerView(){
        weekContainerView.isHidden = true
        monthContainerView.isHidden = true
        yearContainerView.isHidden = false
        UIView.animate(withDuration: 0.2) {
            self.headerLabelStackView.isHidden = false
            self.leftArrowButton.isHidden = true
            self.rightArrowButton.isHidden = true
            self.timeHorizonLabel.text = "\(CalendarHelper().currentYear)"
        }
        setProgressView(for: .Year)
    }
    
    func setProgressView(for timePeriod: TimePeriod){
        progressHeaderView.progress = ProgressController.shared.getCurrentPercentageOfProgress(for: timePeriod)
        
        switch timePeriod{
            
        case .Week:
            let completedTuple = ProgressController.shared.completedOutOfTotal()
            numberCompletedLabel.text = "\(completedTuple.completed) of \(completedTuple.total) Completed"
        case .Month, .Year:
            let possible = UserController.shared.currentUser?.numberOfAvailableWorkouts(for: timePeriod)
            let completed = ProgressController.shared.numberOfCompletedWorkouts(for: timePeriod, user: UserController.shared.currentUser, month: selectedMonth)
            numberCompletedLabel.text = "\(completed) of \(possible ?? 0) Completed"
//        case .Year:
//            let possible = UserController.shared.currentUser?.numberOfAvailableWorkouts(for: timePeriod)
//            let completed = ProgressController.shared.numberOfCompletedWorkouts(for: timePeriod)
//            numberCompletedLabel.text = "\(completed) of \(possible ?? 0) Completed"
        }
    }
    
    func updateProgressView(){
        guard let timePeriod = TimePeriod(rawValue: timeSegmentedControl.selectedSegmentIndex) else {return}
        setProgressView(for: timePeriod)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toWeekContainerView"{
            let weekVC = segue.destination as? WeekProgressViewController
            weekVC?.delegate = self
        } else if segue.identifier == "toMonthContainerView"{
            let monthVC = segue.destination  as? MonthProgressViewController
            self.monthProgressViewController = monthVC
        }
    }
    
    func setUpUI(){
        timeSegmentedControl.addShadow()
        timeSegmentedControl.layer.masksToBounds = true
        //        timeSegmentedControl.layer.cornerRadius = 0
        
        timeSegmentedControl.layer.borderWidth = 0
        timeSegmentedControl.backgroundColor = .white
        timeSegmentedControl.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.lightGray,
            NSAttributedString.Key.font : UIFont(name: "Poppins-Regular", size: 17)
            ], for: .normal)
        progressHeaderView.workoutTitleLabel.isHidden = true
        progressHeaderView.layoutIfNeeded()
    }
    
    func incrementSelectedMonth(){
        
    }
    
    @IBAction func rightArrowTapped(_ sender: Any) {
        
        selectedMonth += 1
        if selectedMonth > 12 { selectedMonth = 1}
        
        timeHorizonLabel.text = CalendarHelper().monthName(for: selectedMonth)
        monthProgressViewController?.selectedMonth = selectedMonth
        setProgressView(for: .Month)
    }
    
    @IBAction func leftArrowTapped(_ sender: Any) {
        selectedMonth -= 1
        if selectedMonth < 1 { selectedMonth = 12 }
        
        timeHorizonLabel.text = CalendarHelper().monthName(for: selectedMonth)
        monthProgressViewController?.selectedMonth = selectedMonth
        setProgressView(for: .Month)
    }
    
}
