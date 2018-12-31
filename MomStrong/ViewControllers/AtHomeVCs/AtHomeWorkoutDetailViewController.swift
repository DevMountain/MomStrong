//
//  AtHomeWorkoutDetailViewController.swift
//  MomStrong
//
//  Created by DevMountain on 11/19/18.
//  Copyright © 2018 trevorAdcock. All rights reserved.
//

import UIKit
import AVKit
import GoogleCast

class AtHomeWorkoutDetailTableViewController: UITableViewController {
    
    
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var completedButton: UIButton!
    @IBOutlet weak var completedBarView: UIView!
    
    var sessionManager: GCKSessionManager{
        return GCKCastContext.sharedInstance().sessionManager
    }
    var castSession: GCKCastSession?{
        return GCKCastContext.sharedInstance().sessionManager.currentCastSession
    }
    
    var workout: Workout?{
        didSet{
            loadViewIfNeeded()
            updateViews()
        }
    }
    
    let castMediaController = GCKUIMediaController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
        sessionManager.add(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        print("# of Section\(workout?.circuits.count ?? 0)")
        return workout?.circuits.count ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let workout = workout else {return 0}
        print("# of items in section #\(section) is \(workout.circuits[section].excercises.count + 1)")
        return workout.circuits[section].excercises.count + 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "workoutSectionCell", for: indexPath) as! WorkoutSectionTableViewCell
            cell.workoutSection = workout?.circuits[indexPath.section]
            if indexPath.section == 0 { cell.separatorView.isHidden = true }
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "exerciseCell", for: indexPath) as! AtHomeExerciseTableViewCell
            guard let exercise =  workout?.circuits[indexPath.section].excercises[indexPath.row - 1] else {return UITableViewCell() }
            cell.exerciseLabel.text = "\(exercise.title)  X  \(exercise.description)"
            return cell
        }
    }
    
    func updateViews(){
        titleLabel.text = workout?.title
        thumbnailImageView.image = workout?.thumbnail
        updateCompletedButton()
    }
    
    func setUpUI(){
        setNavHeaderView()
        self.customizeBackButton()
        
        let castButton = GCKUICastButton()
        castButton.tintColor = UIColor.powerMomRed
        let castBarButton = UIBarButtonItem(customView: castButton)
        
        navigationItem.rightBarButtonItem = castBarButton
    }
    
    func updateCompletedButton(){
        guard let workout = workout else { return }
        guard let isCompleted = UserController.shared.currentUser?.hasCompleted(workout: workout) else { return }
        isCompleted ? markWorkoutComplete() : markWorkoutIncomplete()
    }
    
    func markWorkoutComplete(){
        UIView.animate(withDuration: 0.2) {
            self.completedButton.setImage(#imageLiteral(resourceName: "IDidThis"), for: .normal)
            self.completedBarView.backgroundColor = UIColor.powerMomRed
        }
    }
    
    func markWorkoutIncomplete(){
        UIView.animate(withDuration: 0.2) {
            self.completedButton.setImage(#imageLiteral(resourceName: "MarkAsComplete"), for: .normal)
            self.completedBarView.backgroundColor = UIColor.backgroudGray
        }
    }
    
    @objc func presentAVPlayer(){
        guard let videoUrl = workout?.videoUrl else {return}
        print(videoUrl)
        presentAVPlayerVCWith(videoUrlString: videoUrl)
    }
    
    @IBAction func playButtonTapped(_ sender: Any) {
        presentAVPlayer()
    }
    
    @IBAction func completedButtonTapped(_ sender: Any) {
        guard let workout = workout else { return }
        ProgressController.shared.toggleIsCompleted(for: workout)
        updateCompletedButton()
    }
}


extension AtHomeWorkoutDetailTableViewController: GCKSessionManagerListener {
    
    
    func sessionManager(_ sessionManager: GCKSessionManager, willStart session: GCKSession) {
        print("🥶 Session manager will Start 🥶")
    }
    
    func sessionManager(_ sessionManager: GCKSessionManager, didStart session: GCKSession) {
        print("🥶 Session manager didStart 🥶")
        
        playVideoRemotely()
        
    }
    
    func sessionManager(_ sessionManager: GCKSessionManager, didResumeSession session: GCKSession) {
        print("🥶 Session manager didResumeSession 🥶")
//        playVideoRemotely()
    }
    
    func sessionManager(_ sessionManager: GCKSessionManager, didEnd session: GCKSession, withError error: Error?) {
        session.remoteMediaClient?.stop()
        switchToLocalPlayback()
        if let error = error {
            print("💩  There was an error in \(#function) ; \(error)  ; \(error.localizedDescription)  💩")
        }
        print("🥶 Session Manager Did End 🥶")
    }
    
    func sessionManager(_ sessionManager: GCKSessionManager, didFailToStart session: GCKSession, withError error: Error) {
        print("🥶 Session manager did FailTOStart with error 🥶")
        print("💩  There was an error in \(#function) ; \(error)  ; \(error.localizedDescription)  💩")
    }
    
    func buildMediaInfo(from workout: Workout) -> GCKMediaInformation{
        let metaData = buildMediaMetaData(workout: workout)
        print(workout.videoUrl!)
        let mediaInfo = GCKMediaInformation(contentID: workout.videoUrl!, streamType: .unknown, contentType: "video/mp4", metadata: metaData, adBreaks: nil, adBreakClips: nil, streamDuration: 20.0*60.0, mediaTracks: nil, textTrackStyle: nil, customData: nil)
        return mediaInfo
    }
    
    func buildMediaMetaData(workout: Workout) -> GCKMediaMetadata{
        let metaData = GCKMediaMetadata(metadataType: .generic)
        metaData.setString(workout.title, forKey: kGCKMetadataKeyTitle)
        metaData.setString(workout.description, forKey: kGCKMetadataKeySubtitle)
        if let thumbnailUrl = URL(string: workout.thumbnailUrl ?? ""){
            let gckThumbnail = GCKImage(url: thumbnailUrl, width: 100, height: 100)
            metaData.addImage(gckThumbnail)
        }
        return metaData
    }
    
    func switchToLocalPlayback(){
        castSession?.remoteMediaClient?.stop()
        castSession?.end(with: .stopCasting)
    }
    
    func playVideoRemotely(){
        guard let castSession = castSession else { print("No Current Cast Session") ; return }
        
        castSession.remoteMediaClient?.loadMedia(buildMediaInfo(from: workout!))
        
        Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { (_) in
            GCKCastContext.sharedInstance().presentDefaultExpandedMediaControls()
        }
    }
}
