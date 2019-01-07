//
//  LoginViewController.swift
//  MomStrong
//
//  Created by DevMountain on 11/28/18.
//  Copyright © 2018 trevorAdcock. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
//    @IBOutlet weak var continueTrialButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passwordTextField.delegate = self
        customizeBackButton()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
//    func showOrHideTrialButton(){
//        continueTrialButton.isHidden = true
//        if let trialTuple = UserController.shared.checkForTwoWeekTrial(){
//            if trialTuple.valid {
//                continueTrialButton.isHidden = false
//            }
//        }
//    }
    
    func presentLoginErrorAlert(){
        self.presentSimpleAlert(title: "Whoops We Couldn't Find You", message: "Try typing your username and password again", style: .alert)
    }
    
    
    @IBAction func forgotPasswordButtonTapped(_ sender: Any) {
        //        let currentUser = User(firstName: "John", lastName: "Marshal", dob: nil, location: "UT", subscription: .Both, id: 12)
        //        UserController.shared.currentUser = currentUser
        //        self.presentMainInterface()
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        guard let email = emailTextField.text?.lowercased(),
            let password = passwordTextField.text else { return }
        UserController.shared.loginUserWith(email: email, password: password) { (user) in
            DispatchQueue.main.async {
                guard let _ = user else { self.presentLoginErrorAlert() ; return }
                self.presentMainInterface()
            }
        }
    }
    
//    @IBAction func trialButton(_ sender: Any) {
//        UserController.shared.fetchTrialUserData()
//        self.presentMainInterface()
//    }
}

extension LoginViewController: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
