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
        emailTextField.isUserInteractionEnabled = isBeingEdited
        ageTextField.isUserInteractionEnabled = isBeingEdited
        stateTextField.isUserInteractionEnabled = isBeingEdited
        if !isBeingEdited { }
    }
    
    func updateUserInfo(){
        guard let name = nameTextField.text, !name.isEmpty,
            let email = emailTextField.text, !email.isEmpty,
            let ageString = ageTextField.text, !ageString.isEmpty, let _ = Int(ageString),
            let state = stateTextField.text, !state.isEmpty else {return}
        
        UserController.shared.updateUser(name: name, email: email, age: ageString, state: state) { (success) in
            if success{
                self.presentMomStrongModalVC(title: "Successfully Updated", messageOne: "You're all set!", messageTwo: nil)
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
