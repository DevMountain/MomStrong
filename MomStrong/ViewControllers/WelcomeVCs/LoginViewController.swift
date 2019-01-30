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
  
  override func viewDidLoad() {
    super.viewDidLoad()
    emailTextField.delegate = self
    passwordTextField.delegate = self
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
  }
  
  func presentLoginErrorAlert(error: NetworkError?){
    var title: String!
    var message: String
    switch error {
    case .AccountNoLongerActive?:
      title = "Whoops"
      message = "It looks like your account is no longer active"
    case .UserNotFound?:
      title = "Whoops, something went wrong"
      message = "Please try entering your username and password again"
    default:
      title = "Whoops, something went wrong"
      message = "Please try entering your username and password again"
    }
    DispatchQueue.main.async {
      self.presentSimpleAlert(title: title, message: message, style: .alert)
    }
  }
  
  @IBAction func loginButtonTapped(_ sender: Any) {
    guard let email = emailTextField.text?.lowercased(),
      let password = passwordTextField.text else { return }
    UserController.shared.loginUserWith(email: email, password: password) { (user, networkError) in
      DispatchQueue.main.async {
        if let error = networkError{
          print("\(error.description()) in function: \(#function)")
          self.presentLoginErrorAlert(error: error)
          return
        }
        guard let _ = user else { self.presentLoginErrorAlert(error: networkError) ; return }
        self.presentMainInterface()
      }
    }
  }
}

extension LoginViewController: UITextFieldDelegate{
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
}
