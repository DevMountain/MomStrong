//
//  PlanListTableViewController.swift
//  MomStrong
//
//  Created by DevMountain on 12/12/18.
//  Copyright © 2018 trevorAdcock. All rights reserved.
//

import UIKit

class PlanListTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    var plans: [(title: String, description: String)] = []

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return plans.count
    }

//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "planCell", for: indexPath)
//        
//        cell.textLabel?.text = 
//        // Configure the cell...
//
//        return cell
//    }
}
