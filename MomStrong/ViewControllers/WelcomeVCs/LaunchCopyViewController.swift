//
//  LaunchCopyViewController.swift
//  MomStrong
//
//  Created by DevMountain on 11/27/18.
//  Copyright © 2018 trevorAdcock. All rights reserved.
//

import UIKit

class LaunchCopyViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchCurrentUser()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    func fetchCurrentUser(){
        UserController.shared.fetchCurrentUser { (user, networkError) in
            DispatchQueue.main.async {
                if let networkError = networkError {
                    self.presentWelcomeVC()
                    print("💩  There was an error in \(#function) ; \(networkError.description()) 💩")
                    
                }else {
                    self.presentMainInterface()
                }
            }
        }
    }
}
