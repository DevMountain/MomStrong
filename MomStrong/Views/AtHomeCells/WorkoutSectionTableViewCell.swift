//
//  WorkoutSectionTableViewCell.swift
//  MomStrong
//
//  Created by DevMountain on 11/19/18.
//  Copyright © 2018 trevorAdcock. All rights reserved.
//

import UIKit

class WorkoutSectionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var sectionTitleLabel: UILabel!
    @IBOutlet weak var sectionDescriptionLabel: UILabel!
    
    @IBOutlet weak var exerciseTableView: SelfSizingTableView!
    
    override func awakeFromNib() {
        exerciseTableView.dataSource = self
        exerciseTableView.delegate = self
    }
    
    var workoutSection: Circuit?{
        didSet{
            updateViews()
        }
    }

    func updateViews(){
        sectionTitleLabel.text = workoutSection?.title
        sectionDescriptionLabel.text = workoutSection?.description
        
    }
}

extension WorkoutSectionTableViewCell: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return workoutSection?.setGroups?.count ?? 0
        return workoutSection?.excercises.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "exerciseCell", for: indexPath)
//        let setGroup = workoutSection?.setGroups[indexPath.row]
//        cell.textLabel?.text = setGroup?.exercise.name
//        cell.detailTextLabel?.text = "\(setGroup?.sets ?? [])"
        
        let exercise = workoutSection?.excercises[indexPath.row]
        cell.textLabel?.text = exercise?.title
        cell.detailTextLabel?.text = exercise?.description
        return cell
    }
    
    
}
