//
//  GymExerciseCell.swift
//  MomStrong
//
//  Created by DevMountain on 12/19/18.
//  Copyright © 2018 trevorAdcock. All rights reserved.
//

import UIKit

class GymExerciseCell: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var exerciseTitle: CustomLabel!
    @IBOutlet weak var exerciseDescriptionLabel: CustomLabel!
    @IBOutlet weak var exerciseThumbnailImageView: ThumbNailImageView!
    @IBOutlet var contentStackView: UIStackView!
    
    var viewController: UIViewController?
    var exercise: Exercise?
    
    override var intrinsicContentSize: CGSize {
        var height = exerciseTitle.intrinsicContentSize.height
        if exerciseDescriptionLabel.text != ""{
            height += exerciseDescriptionLabel.intrinsicContentSize.height
        }
        return CGSize(width: UIView.noIntrinsicMetric, height: height)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    convenience init(with exercise: Exercise, viewController: UIViewController?){
        self.init()
        commonInit()
        self.viewController = viewController
        self.exercise = exercise
        exerciseTitle.text = exercise.title
        exerciseDescriptionLabel.text = exercise.description
        self.exerciseThumbnailImageView.isHidden = exercise.vimeoUrl == nil
        self.exerciseThumbnailImageView.urlString = exercise.thumbnailUrl
        if exercise.description.isEmpty { exerciseDescriptionLabel.isHidden = true }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit(){
        Bundle.main.loadNibNamed("GymExerciseCell", owner: self, options: nil)
        self.translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    private func presentExerciseVideoVC(){
        guard let exercise = exercise,
            let url = exercise.videoUrl else {
                return
        }
        print(url)
        self.viewController?.presentAVPlayerVCWith(videoUrlString: url)
    }
    
    @IBAction func playButtonTapped(_ sender: UIButton) {
        presentExerciseVideoVC()
    }
    
    @IBAction func imageThumbnailTapped(_ sender: Any) {
        presentExerciseVideoVC()
    }
}
