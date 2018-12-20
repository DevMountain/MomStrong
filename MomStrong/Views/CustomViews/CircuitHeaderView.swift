//
//  CircuitHeaderView.swift
//  MomStrong
//
//  Created by DevMountain on 12/20/18.
//  Copyright © 2018 trevorAdcock. All rights reserved.
//

import UIKit

class CircuitHeaderView: UIView {


    @IBOutlet var contentView: UIView!
    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var circuitDescriptionLabel: CustomLabel!
    @IBOutlet weak var circuitTitleLabel: CustomLabel!
    
    override var intrinsicContentSize: CGSize {
        let height = circuitTitleLabel.intrinsicContentSize.height + circuitDescriptionLabel.intrinsicContentSize.height + separatorView.intrinsicContentSize.height
        return CGSize(width: UIView.noIntrinsicMetric, height: height)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    convenience init(with circuit: Circuit){
        self.init()
        commonInit()
        circuitTitleLabel.text = circuit.title
        circuitDescriptionLabel.text = circuit.description
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit(){
        Bundle.main.loadNibNamed("CircuitHeader", owner: self, options: nil)
        self.translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 1000), for: .vertical)
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
}
