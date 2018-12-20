//
//  PasswordResetViewController.swift
//  MomStrong
//
//  Created by DevMountain on 12/10/18.
//  Copyright © 2018 trevorAdcock. All rights reserved.
//

import UIKit

class PasswordResetViewController: UIViewController, UITextFieldDelegate{

    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeBackButton()
        emailTextField.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        // Do any additional setup after loading the view.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func sendEmailButtonTapped(_ sender: Any) {
        guard let email = emailTextField.text, !email.isEmpty else { return }
        UserController.shared.sendResetPasswordRequestFor(email: email) { (success) in
            DispatchQueue.main.async {
                self.presentMomStrongModalVC(title: "Password Reset", messageOne: "Please check your email for a password reset link.", messageTwo: "We'll see you soon!")
            }
        }
        emailTextField.text = ""
    }
}
