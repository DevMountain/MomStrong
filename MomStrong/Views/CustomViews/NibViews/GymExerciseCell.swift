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
    @IBOutlet weak var exerciseThumbnailImageView: UIImageView!
    @IBOutlet var contentStackView: UIStackView!
    
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
    
    convenience init(with exercise: Exercise){
        self.init()
        commonInit()
        exerciseTitle.text = exercise.title
        exerciseDescriptionLabel.text = exercise.description
        self.exerciseThumbnailImageView.isHidden = exercise.videoUrl == nil
        WorkoutController.shared.fetchVideoInfo(for: exercise) { (exercise) in
            guard let thumbnailUrl = exercise?.thumbnailUrl else { return }
            VimeoClient.fetchThumbnail(url: thumbnailUrl, completion: { (image) in
                DispatchQueue.main.async {
                    self.exerciseThumbnailImageView.image = image
                }
            })
        }
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
}
