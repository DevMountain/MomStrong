//
//  PlanListTableViewController.swift
//  MomStrong
//
//  Created by DevMountain on 12/12/18.
//  Copyright © 2018 trevorAdcock. All rights reserved.
//

import UIKit

class PlanListTableViewController: UITableViewController {
    
    @IBOutlet weak var twoWeekTrialButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.plans = UserController.shared.loadAllPlans()
        self.customizeBackButton()
        self.setNavHeaderView()
//        updateTrialButton()
        twoWeekTrialButton.stylize()
        self.navigationController?.hidesBarsOnSwipe = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
//    func updateTrialButton(){
//        if let trialTuple = UserController.shared.checkForTwoWeekTrial(){
//            if !trialTuple.valid {
//                twoWeekTrialButton.isHidden = true
//            }else{
//                twoWeekTrialButton.setTitle("Contune Your Trial - \(trialTuple.daysLeft) days remaining!", for: .normal)
//            }
//        }else{
//            twoWeekTrialButton.setTitle("Start Your 2 week free trial", for: .normal)
//        }
//    }
    
    var plans: [Plan] = []

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return plans.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "planCell", for: indexPath)
        let plan = plans[indexPath.row]
        cell.textLabel?.text = plan.title
        cell.detailTextLabel?.text = plan.description
        return cell
    }
    
//    @IBAction func twoWeekTrialButtonTapped(_ sender: Any) {
//        if let trialTuple = UserController.shared.checkForTwoWeekTrial(){
//            let isTrialValid = trialTuple.valid
//            if !isTrialValid{
//                self.presentMomStrongModalVC(title: "Your Trial Has Expired", messageOne: "Please visit our website to subscribe for a full account", messageTwo: nil)
//                return
//            }else{
//                UserController.shared.fetchTrialUserData()
//                self.presentMainInterface()
//            }
//        }else{
//            UserController.shared.createTwoWeekTrial()
//            self.presentMainInterface()
//        }
//    }
}

