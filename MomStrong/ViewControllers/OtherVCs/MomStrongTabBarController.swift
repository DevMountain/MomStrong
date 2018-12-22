//
//  MomStrongTabBarController.swift
//  MomStrong
//
//  Created by DevMountain on 11/15/18.
//  Copyright © 2018 trevorAdcock. All rights reserved.
//

import UIKit

class MomStrongTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let progress = UIStoryboard(name: "Progress", bundle: .main).instantiateInitialViewController(),
            var atHome = UIStoryboard(name: "Main", bundle: .main).instantiateInitialViewController(),
            var gymRat = UIStoryboard(name: "Gymrat", bundle: .main).instantiateInitialViewController(),
            let vc = UIStoryboard(name: "ModalPresentations", bundle: .main).instantiateInitialViewController(),
            let lockVC = vc as? ModalPopUpViewController else { return }
        
            let currentUser = UserController.shared.currentUser!
        
        var atHomeImage: UIImage = #imageLiteral(resourceName: "LockIcon")
        var gymRatImage: UIImage = #imageLiteral(resourceName: "LockIcon")
 
        lockVC.popUptitle = "Subscribe for Access"
        lockVC.messageOne = "It looks like you don't have access to this plan.  Please subcribe on our site and log into the app to see more!"
        lockVC.messageTwo = nil
        lockVC.view.backgroundColor = UIColor.backgroudGray
        lockVC.cancelButton.isHidden = true
        
        
        switch currentUser.subscription {
        case .AtHome:
            atHomeImage = #imageLiteral(resourceName: "Home_Active")
            gymRat = lockVC
            
        case .Gymrat:
            gymRatImage = #imageLiteral(resourceName: "Gym_Active")
            atHome = lockVC
            
        case .Both:
            atHomeImage = #imageLiteral(resourceName: "Home_Active")
            gymRatImage = #imageLiteral(resourceName: "Gym_Active")
            
        case .None:
            gymRat = lockVC
            atHome = lockVC
        }
        
        progress.tabBarItem = UITabBarItem(title: "Progress", image: #imageLiteral(resourceName: "ProgressIcon"), tag: 0)
        atHome.tabBarItem = UITabBarItem(title: "AtHome", image: atHomeImage, tag: 1)
        gymRat.tabBarItem = UITabBarItem(title: "GymRat", image: gymRatImage, tag: 2)
        
        tabBar.tintColor = UIColor.powerMomRed
        self.viewControllers = [progress,atHome,gymRat]
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
