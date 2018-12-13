//
//  MomStrongModalMessageView.swift
//  MomStrong
//
//  Created by DevMountain on 12/12/18.
//  Copyright © 2018 trevorAdcock. All rights reserved.
//

import UIKit

class MomStrongModalMessageView: UIView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var message1Label: UILabel!
    @IBOutlet weak var message2Label: UILabel!
    @IBOutlet var bgView: UIView!
    
    var title: String{
        didSet{
            titleLabel.text = title
        }
    }
    var messageOne: String{
        didSet{
            message1Label.text = messageOne
        }
    }
    var messageTwo: String?{
        didSet{
            message2Label.text = messageTwo
        }
    }
    weak var owner: UIViewController?
    
    init(title: String, messageOne: String, messageTwo: String?, owner: UIViewController){
        self.title = title
        self.messageOne = messageOne
        
        if let messageTwo = messageTwo{
            self.messageTwo = messageTwo
        }else {
            message2Label.isHidden = true
        }
        
        self.owner = owner
        super.init(frame: owner.view.frame)
        commonInit()
        updateViews()
    }
    
    func updateViews(){
        titleLabel.text = title
        message1Label.text = messageOne
        message2Label.text = messageTwo
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Mom Strong Modal View CANNOT Be called from InterfaceBuilder")
    }
    
    private func commonInit(){
        Bundle.main.loadNibNamed("MomStrongModalMessage", owner: self, options: nil)
        addSubview(bgView)
        bgView.frame = self.bounds
        bgView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    

    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.removeFromSuperview()
        owner?.view.layoutIfNeeded()
    }
    
}
