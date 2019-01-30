//
//  GymExerciseCell.swift
//  MomStrong
//
//  Created by DevMountain on 12/19/18.
//  Copyright © 2018 trevorAdcock. All rights reserved.
//

import UIKit

class GymExerciseTableViewCell: UITableViewCell {
    
    @IBOutlet weak var exerciseTitleLabel: CustomLabel!
    @IBOutlet weak var exerciseDescriptionLabel: CustomLabel!
    @IBOutlet weak var exerciseThumbnailImageView: ThumbNailImageView!
    
    var viewController: UIViewController?
    var exercise: Exercise?{
        didSet{
            updateViews()
        }
    }

    private func updateViews(){
        guard let exercise = exercise else { return }
        exerciseTitleLabel.text = exercise.title
        exerciseDescriptionLabel.text = exercise.description
        loadVideoInfo()
    }
    
    private func loadVideoInfo(){
        guard let exercise = exercise else { return }
        WorkoutController.shared.fetchVideoInfo(for: exercise) { (exercise) in
            DispatchQueue.main.async {
                self.exerciseThumbnailImageView.urlString = exercise?.thumbnailUrl
            }
        }
    }
    
    private func presentExerciseVideoVC(){
        guard let exercise = exercise,
            let url = exercise.videoUrl else {
                return
        }
        self.viewController?.presentAVPlayerVCWith(videoUrlString: url)
    }
    
    @IBAction func playButtonTapped(_ sender: UIButton) {
        presentExerciseVideoVC()
    }
}
