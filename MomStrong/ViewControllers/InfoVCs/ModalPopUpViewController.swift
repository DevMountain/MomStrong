//
//  ModalPopUpViewController.swift
//  MomStrong
//
//  Created by DevMountain on 12/12/18.
//  Copyright © 2018 trevorAdcock. All rights reserved.
//

import UIKit

class ModalPopUpViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageOneLabel: UILabel!
    @IBOutlet weak var messageTwoLabel: UILabel!
    
    var popUptitle: String = ""{
        didSet{
            loadViewIfNeeded()
            titleLabel.text = popUptitle
        }
    }
    var messageOne: String = ""{
        didSet{
            loadViewIfNeeded()
            messageOneLabel.text = messageOne
        }
    }
    var messageTwo: String? = ""{
        didSet{
            loadViewIfNeeded()
            messageTwoLabel.text = messageTwo
        }
    }
    
    func updateViews(){
        titleLabel.text = title
        messageOneLabel.text = messageOne
        messageTwoLabel.text = messageTwo
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        
        view.isOpaque = false
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
