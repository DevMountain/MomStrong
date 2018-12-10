//
//  ProgressHeaderView.swift
//  MomStrong
//
//  Created by DevMountain on 11/30/18.
//  Copyright © 2018 trevorAdcock. All rights reserved.
//

import UIKit

class ProgressHeaderView: UIView{
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var workoutTypeLabel: UILabel!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var workoutProgressView: UIProgressView!
    
    var progress: Float?{
        didSet{
            updateProgressView()
        }
    }
    
    var workoutType: String?{
        didSet{
            workoutTypeLabel.text = workoutType
        }
    }
    
    func updateProgressView(){
        guard let progress = progress else { return }
        progressLabel.text = progress.asPercentString
        workoutProgressView.setProgress(progress, animated: true)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit(){
        Bundle.main.loadNibNamed("ProgressHeaderView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
}
