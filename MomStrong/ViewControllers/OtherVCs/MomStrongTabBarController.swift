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
            let atHome = UIStoryboard(name: "Main", bundle: .main).instantiateInitialViewController(),
            let gymRat = UIStoryboard(name: "Gymrat", bundle: .main).instantiateInitialViewController(),
            let currentUser = UserController.shared.currentUser else {return}
        
        var atHomeImage: UIImage = #imageLiteral(resourceName: "LockIcon")
        var gymRatImage: UIImage = #imageLiteral(resourceName: "LockIcon")
        var atHomeEnabled: Bool = false
        var gymRatEnabled: Bool = false
        
        switch currentUser.subscription {
        case .AtHome:
            atHomeImage = #imageLiteral(resourceName: "Home_Active")
            atHomeEnabled = true
            
        case .Gymrat:
            gymRatImage = #imageLiteral(resourceName: "Gym_Active")
            gymRatEnabled = true
            
        case .Both:
            atHomeImage = #imageLiteral(resourceName: "Home_Active")
            gymRatImage = #imageLiteral(resourceName: "Gym_Active")
            atHomeEnabled = true
            gymRatEnabled = true
            
        case .None:
            print("No Subscription Found")
        }
        
        progress.tabBarItem = UITabBarItem(title: "Progress", image: #imageLiteral(resourceName: "ProgressIcon"), tag: 0)
        atHome.tabBarItem = UITabBarItem(title: "AtHome", image: atHomeImage, tag: 1)
        gymRat.tabBarItem = UITabBarItem(title: "GymRat", image: gymRatImage, tag: 2)
        atHome.tabBarItem.isEnabled = atHomeEnabled
        gymRat.tabBarItem.isEnabled = gymRatEnabled
        
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
