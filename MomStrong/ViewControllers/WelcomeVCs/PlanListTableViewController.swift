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
        self.plans = loadPlans()
        self.customizeBackButton()
        self.setNavHeaderView()
        twoWeekTrialButton.stylize()
    }
    
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
    
    @IBAction func twoWeekTrialButtonTapped(_ sender: Any) {
        if let trialTuple = UserController.shared.checkForTwoWeekTrial(){
            let isTrialValid = trialTuple.valid
            if !isTrialValid{
                self.presentMomStrongModalVC(title: "Your Trial Has Expired", messageOne: "Please visit our website to subscribe for a full account", messageTwo: nil)
                return
            }else{
                UserController.shared.fetchTrialUserData()
                self.presentMainInterface()
            }
        }else{
            UserController.shared.createTwoWeekTrial()
            self.presentMainInterface()
        }
    }
}


extension PlanListTableViewController{
    
    func loadPlans() -> [Plan]{
        let atHome = Plan(title: "AtHome", description:
        """
        For only $9.99/Month you with receive two at home workouts each week. These workouts span between 20-40 minutes. Minimal equipment required. Don’t forget your water!
        """)
        let gymRat = Plan(title: "Gym", description:
            """
        For only $9.99/Month you with receive two at gym workouts each week. These workouts include step-by-step instruction for a gym workout. These workouts are between 30 to 60 minutes long. Workouts include total body and specific muscle groups.
        """)
        let both = Plan(title: "AtHome + Gym", description:
            """
        For only $16.99/Month you with receive Meg’s entire training plan. Both AtHome and Gym Plans every week!
        """)
        
        return [atHome, gymRat, both]
    }
}
