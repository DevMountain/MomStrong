//
//  MonthProgressViewController.swift
//  MomStrong
//
//  Created by DevMountain on 11/25/18.
//  Copyright © 2018 trevorAdcock. All rights reserved.
//

import UIKit

class MonthProgressViewController: UIViewController {

    @IBOutlet weak var calendarCollectionView: UICollectionView!
    
    let calendarHelper = CalendarHelper()
    var selectedMonth: Int = CalendarHelper().currentMonth{
        didSet{
            calendarCollectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        calendarCollectionView.dataSource = self
        calendarCollectionView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        calendarCollectionView.reloadData()
    }
}

extension MonthProgressViewController: UICollectionViewDataSource, UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return calendarHelper.numberOfDaysIn(month: selectedMonth)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "calendarCell", for: indexPath) as? CalendarCollectionViewCell
        guard let currentUser = UserController.shared.currentUser else {return UICollectionViewCell() }
        let completedWorkoutsDates = ProgressController.shared.filterProgressPointsFor(month: selectedMonth, user: currentUser).compactMap{ $0.dateCompleted }
        let workoutDays = completedWorkoutsDates.compactMap{ Calendar.current.dateComponents([.day], from: $0).day }
        cell?.addShadow()
        cell?.isCompleteImage.image = workoutDays.contains(indexPath.row + 1) ? #imageLiteral(resourceName: "Checkmark_fill") : nil
        cell?.dateLabel.text = "\(indexPath.row + 1)"
        return cell ?? CalendarCollectionViewCell()
    }
}
