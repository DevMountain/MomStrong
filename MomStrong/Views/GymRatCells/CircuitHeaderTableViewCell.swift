//
//  CircuitHeaderView.swift
//  MomStrong
//
//  Created by DevMountain on 12/20/18.
//  Copyright © 2018 trevorAdcock. All rights reserved.
//

import UIKit

class CircuitHeaderTableViewCell: UITableViewCell {

    //MARK: - IBOUTLETS
    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var circuitTitleLabel: UILabel!
    @IBOutlet weak var circuitDescriptionLabel : UILabel!

    var circuit: Circuit?{
        didSet{
            updateViews()
        }
    }
    
    func updateViews(){
        circuitTitleLabel.text = circuit?.title
        circuitDescriptionLabel.text = circuit?.description
    }
}
