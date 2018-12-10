//
//  GymExerciseTableViewCell.swift
//  MomStrong
//
//  Created by DevMountain on 11/19/18.
//  Copyright © 2018 trevorAdcock. All rights reserved.
//

import UIKit
import AVKit

class GymExerciseTableViewCell: UITableViewCell {
    
    @IBOutlet weak var exerciseTitleLabel: UILabel!
    @IBOutlet weak var setsLabel: UILabel!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    
    weak var delegate: GymWorkoutTableViewCellDelegate?
    
    var exercise: Exercise?{
        didSet{
            updateViews()
        }
    }
    
    var isLoading: Bool = false
    
    var fullExercise: Exercise?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func updateViews(){
        guard let exercise = exercise else { return }
        exerciseTitleLabel.text = exercise.title
        setsLabel.text = exercise.description
        let spinner = UIView.displaySpinner(onView: thumbnailImageView)
        isLoading = true
        WorkoutController.shared.fetchVideoInfo(for: exercise) { (exercise) in
            guard let thumbnailUrl = exercise?.thumbnailUrl else { return }
            self.fullExercise = exercise
            VimeoClient.fetchThumbnail(url: thumbnailUrl, completion: { (image) in
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.thumbnailImageView.image = image
                    UIView.removeSpinner(spinner: spinner)
                }
            })
        }
    }
    
    func setUpUI(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(thumbNailWasTapped))
        tap.numberOfTapsRequired = 1
        thumbnailImageView.isUserInteractionEnabled = true
        self.isUserInteractionEnabled = true
        thumbnailImageView.superview?.isUserInteractionEnabled = true
        thumbnailImageView.addGestureRecognizer(tap)
    }
    
    @objc func thumbNailWasTapped(){
        print("tapped")
        guard !isLoading,
            let urlString = fullExercise?.videoUrl,
            let url = URL(string: urlString) else {return}
        let player = AVPlayer(url: url)
        delegate?.presentAVPlayerVC(with: player)
    }
}
