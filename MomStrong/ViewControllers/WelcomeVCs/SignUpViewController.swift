//
//  SignUpViewController.swift
//  MomStrong
//
//  Created by DevMountain on 11/28/18.
//  Copyright © 2018 trevorAdcock. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: CustomTextField!
    @IBOutlet weak var emailTextField: CustomTextField!
    @IBOutlet weak var passwordTextField: CustomTextField!
    @IBOutlet weak var ageTextField: CustomTextField!
    @IBOutlet weak var stateTextField: CustomTextField!
    @IBOutlet weak var acceptedButton: UIButton!
    @IBOutlet weak var acceptedbgView: UIView!
    
    var acceptedTOS: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    func setUpUI(){
        customizeBackButton()
        acceptedbgView.addShadow()
        [emailTextField,passwordTextField,ageTextField,stateTextField].forEach{
            $0?.delegate = self
            $0?.layer.masksToBounds = false
            $0?.addShadow()
        }
    }
    
    func updateAcceptedButton(){
        let image = acceptedTOS ? #imageLiteral(resourceName: "Checkmark_fill") : nil
        acceptedButton.setImage(image, for: .normal)
    }
    
    @IBAction func acceptedButtonTapped(_ sender: Any) {
        acceptedTOS.toggle()
        updateAcceptedButton()
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        self.resignFirstResponder()
        guard acceptedTOS else { presentSimpleAlert(title: "Whoops", message: "Please accept our Terms of Service to Continue", style: .alert) ; return }
        guard let name = nameTextField.text, !name.isEmpty,
            let email = emailTextField.text, !email.isEmpty,
            let password = passwordTextField.text, !password.isEmpty,
            let age = ageTextField.text, !age.isEmpty, Int(age) != nil,
            let state = stateTextField.text, !state.isEmpty else {presentSimpleAlert(title: "Whoops", message: "Looks like some of your information is missing above.", style: .alert) ; return }
        
        let spinner = UIView.displaySpinner(onView: self.view)
        UserController.shared.signUserUpForTwoWeekTrial(name: name, email: email, password: password, age: age, state: state) { (user) in
            guard let user = user else { return }
            UserController.shared.currentUser = user
            UIView.removeSpinner(spinner: spinner)
            self.presentMainInterface()
        }
    }
    
    @IBAction func termsOfServiceButton(_ sender: Any) {
        
    }
}

extension SignUpViewController: UITextFieldDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        guard textField != nameTextField, textField != emailTextField else { return }
        UIView.animate(withDuration: 0.2) {
            self.shiftKeyboardUp()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.2) {
            self.shiftFrameBackDown()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func shiftKeyboardUp(){
        if self.view.frame.origin.y == 0 {
            self.view.frame.origin.y -= self.view.frame.height / 4
        }
    }
}
