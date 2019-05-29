//
//  ProgressViewController.swift
//  MomStrong
//
//  Created by DevMountain on 11/25/18.
//  Copyright © 2018 trevorAdcock. All rights reserved.
//

import UIKit

class ProgressViewController: UIViewController {
    
    @IBOutlet weak var timeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var weekContainerView: UIView!
    @IBOutlet weak var monthContainerView: UIView!
    @IBOutlet weak var yearContainerView: UIView!
    @IBOutlet weak var timeSectionLabel: UILabel!
    
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
            self.timeSectionLabel.text = "Personal Goals"
        }
    }
    
    func showMonthContainerView(){
        weekContainerView.isHidden = true
        monthContainerView.isHidden = false
        yearContainerView.isHidden = true
        UIView.animate(withDuration: 0.2) {
            self.timeSectionLabel.text = "Days I completed my workout"
        }
    }
    
    func showYearContainerView(){
        weekContainerView.isHidden = true
        monthContainerView.isHidden = true
        yearContainerView.isHidden = false
        UIView.animate(withDuration: 0.2) {
            self.timeSectionLabel.text = "My Year of Momstrong Move Progress"
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMonthContainerView"{
            let monthVC = segue.destination  as? MonthProgressViewController
            self.monthProgressViewController = monthVC
        }else if segue.identifier == "toWeekContainerView"{
            let weekVC = segue.destination as? WeekProgressViewController
            weekVC?.delegate = self
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
            NSAttributedString.Key.font : UIFont(name: "Poppins-Regular", size: 17)!
            ], for: .normal)
    }
    
    @IBAction func rightArrowTapped(_ sender: Any) {
        
        selectedMonth += 1
        if selectedMonth > 12 { selectedMonth = 1}
        
        monthProgressViewController?.selectedMonth = selectedMonth
    }
    
    @IBAction func leftArrowTapped(_ sender: Any) {
        selectedMonth -= 1
        if selectedMonth < 1 { selectedMonth = 12 }
        monthProgressViewController?.selectedMonth = selectedMonth
    }
    
}

extension ProgressViewController: SegmentProgressViewControllerDelegate{
    func disableSegmentedControl() {
        self.timeSegmentedControl.isEnabled = false
    }
    
    func enableSegmentedControl() {
        self.timeSegmentedControl.isEnabled = true
    }
    
    
}

