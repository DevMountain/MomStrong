//
//  AccountViewController.swift
//  MomStrong
//
//  Created by DevMountain on 12/10/18.
//  Copyright © 2018 trevorAdcock. All rights reserved.
//

import UIKit

class AccountViewController: UIViewController {

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
        // Do any additional setup after loading the view.
    }
    
    func setUpUI(){
        customizeBackButton()
        editButton.layer.cornerRadius = 4
        editButton.layer.borderColor = UIColor.powerMomRed.cgColor
        editButton.tintColor = .powerMomRed
        editButton.layer.borderWidth = 1.5
        setEditButtonTitle()
    }
    
    func toggleEditting(){
        isBeingEdited.toggle()
        emailTextField.isUserInteractionEnabled = isBeingEdited
        ageTextField.isUserInteractionEnabled = isBeingEdited
        stateTextField.isUserInteractionEnabled = isBeingEdited
    }
    
    func setEditButtonTitle(){
        let editButtonTitle = isBeingEdited ? "Save" : "Edit"
        editButton.setTitle(editButtonTitle, for: .normal)
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
