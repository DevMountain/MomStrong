//
//  AccountViewController.swift
//  MomStrong
//
//  Created by DevMountain on 12/10/18.
//  Copyright © 2018 trevorAdcock. All rights reserved.
//

import UIKit

class AccountViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var stateTextField: UITextField!
    @IBOutlet weak var planLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var subscribedImageView: UIImageView!
    @IBOutlet weak var planDescriptionLabel: UILabel!
    
    var isBeingEdited: Bool = false
    var accountTextFields: [UITextField]{
        return [nameTextField, emailTextField, ageTextField, stateTextField]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    func setUpUI(){
        customizeBackButton()
        editButton.stylize()
        setEditButtonTitle()
    }
    
    func toggleEditting(){
        isBeingEdited.toggle()
        accountTextFields.forEach{ $0.isUserInteractionEnabled = isBeingEdited }
        accountTextFields.forEach{ toggleTextFieldStyle($0) }
        if !isBeingEdited { updateUserInfo() }
    }
    
    func toggleTextFieldStyle(_ textField: UITextField){
        print(isBeingEdited)
        textField.borderStyle = isBeingEdited ? .roundedRect : .none
    }
    
    func updateUserInfo(){
        guard let name = nameTextField.text, !name.isEmpty,
            let email = emailTextField.text, !email.isEmpty,
            let ageString = ageTextField.text, !ageString.isEmpty, let _ = Int(ageString),
            let state = stateTextField.text, !state.isEmpty else {return}
        
        UserController.shared.updateUser(name: name, email: email, age: ageString, state: state) { (success) in
            if success{
                DispatchQueue.main.async {
                    self.presentMomStrongModalVC(title: "Successfully Updated", messageOne: "You're all set!", messageTwo: nil)
                }
            }
        }
    }
    
    func setEditButtonTitle(){
        let editButtonTitle = isBeingEdited ? "Save" : "Edit"
        editButton.setTitle(editButtonTitle, for: .normal)
    }
    
    func updateViews(){
        guard let currentUser = UserController.shared.currentUser else { return }
        nameTextField.text = currentUser.name
        stateTextField.text = "UT"
        ageTextField.text = "\(currentUser.age ?? 0)"
//        emailTextField.text = currentUser.email
    }

    @IBAction func editButtonTapped(_ sender: Any) {
        toggleEditting()
        setEditButtonTitle()
    }
    
    @IBAction func unsubscribeButtonTapped(_ sender: Any) {
        self.presentMomStrongModalVC(title: "Please Visit Our Site", messageOne: "Unfortunately we don't support unsubscribing from within the app currently.  Please check our website to adjust your settings.", messageTwo: nil)
    }
    
    @IBAction func upgradeButtonTapped(_ sender: Any) {
        self.presentMomStrongModalVC(title: "Please Visit Our Site", messageOne: "Unfortunately we don't support subsction purchases from within the app.  Please check our website to adjust your settings.", messageTwo: nil)
    }
}
