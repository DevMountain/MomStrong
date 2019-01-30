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
            let gymRat = UIStoryboard(name: "Gymrat", bundle: .main).instantiateInitialViewController() else { return }
        
//        let vc = UIStoryboard(name: "ModalPresentations", bundle: .main).instantiateInitialViewController()
//            let lockVC = vc as? ModalPopUpViewController
            let currentUser = UserController.shared.currentUser!
        
        var atHomeImage: UIImage = #imageLiteral(resourceName: "LockIcon")
        var gymRatImage: UIImage = #imageLiteral(resourceName: "LockIcon")
 
//        lockVC.popUptitle = "Learn More"
//        lockVC.messageOne = "To learn more about Momstrong Move, please visit our website."
//        lockVC.messageTwo = nil
//        lockVC.view.backgroundColor = UIColor.backgroudGray
//        lockVC.cancelButton.isHidden = true
        
        var atHomeEnabled: Bool = true
        var gymEnabled: Bool = true
        
        switch currentUser.subscription {
        case .AtHome:
            atHomeImage = #imageLiteral(resourceName: "Home_Active")
            gymEnabled = false
//            gymRat = lockVC
            
        case .Gymrat:
            gymRatImage = #imageLiteral(resourceName: "Gym_Active")
            atHomeEnabled = false
//            atHome = lockVC
            
        case .Both:
            atHomeImage = #imageLiteral(resourceName: "Home_Active")
            gymRatImage = #imageLiteral(resourceName: "Gym_Active")
            
        case .None:
            atHomeEnabled = false
            gymEnabled = false
//            gymRat = lockVC
//            atHome = lockVC
        }
        
        progress.tabBarItem = UITabBarItem(title: "Progress", image: #imageLiteral(resourceName: "ProgressIcon"), tag: 0)
        atHome.tabBarItem = UITabBarItem(title: "Home Strong", image: atHomeImage, tag: 1)
        atHome.tabBarItem.isEnabled = atHomeEnabled
        gymRat.tabBarItem = UITabBarItem(title: "Gym Strong", image: gymRatImage, tag: 2)
        gymRat.tabBarItem.isEnabled = gymEnabled
        
        tabBar.tintColor = UIColor.powerMomRed
        self.viewControllers = [progress,atHome,gymRat]
    }
}
