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
  
  var castButton: GCKUICastButton!
  let sessionManager = ChromeCastController.shared.sessionManager
  let castSession = ChromeCastController.shared.sessionManager.currentCastSession
  let castMediaController = GCKUIMediaController()
  var playbackMode: PlaybackMode = .none
  
  var workout: Workout?{
    didSet{
      loadViewIfNeeded()
      updateViews()
    }
  }
  
  //MARK: - View Life Cycle Methods
  override func viewDidLoad() {
    super.viewDidLoad()
    setUpUI()
//    NotificationCenter.default.addObserver(self, selector: #selector(castDeviceDidChange),
//                                           name: NSNotification.Name.gckCastStateDidChange,
//                                           object: GCKCastContext.sharedInstance())
    
    sessionManager.add(self)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
    if sessionManager.hasConnectedSession(), playbackMode != .remote {
      playSelectedItemRemotely()
      sessionManager.add(self)
    }
  }
  
  override func viewWillDisappear(_ animated: Bool) {
//    sessionManager.remove(self)
    super.viewWillDisappear(animated)
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
    castButton = GCKUICastButton()
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


extension AtHomeWorkoutDetailTableViewController: GCKSessionManagerListener, GCKRemoteMediaClientListener, GCKRequestDelegate {
  
  func sessionManager(_ sessionManager: GCKSessionManager, willStart session: GCKSession) {
    print("🥶 Session manager will Start 🥶")
  }
  
  func sessionManager(_ sessionManager: GCKSessionManager, didStart session: GCKSession) {
    print("🥶 Session manager didStart 🥶")
    playSelectedItemRemotely()
  }
  
  func sessionManager(_ sessionManager: GCKSessionManager, didResumeSession session: GCKSession) {
    print("🥶 Session manager didResumeSession 🥶")
    playSelectedItemRemotely()
  }
  
  func sessionManager(_ sessionManager: GCKSessionManager, didEnd session: GCKSession, withError error: Error?) {
    switchToLocalPlayback()
    if let error = error {
      print("💩  There was an error in \(#function) ; \(error)  ; \(error.localizedDescription)  💩")
    }
    print("🥶 Session Manager Did End 🥶")
  }
  
  func sessionManager(_ sessionManager: GCKSessionManager, didFailToStart session: GCKSession, withError error: Error) {
    print("🥶 Session manager did FailTOStart with error 🥶")
    print("💩  There was an error in \(#function) ; \(error)  ; \(error.localizedDescription)  💩")
    presentSimpleAlert(title: "Failed to start a casting session", message: error.localizedDescription, style: .alert)
  }
  
  func playSelectedItemRemotely() {
    guard let workout = workout, playbackMode != .remote else { return }
    playbackMode = .remote
    castSession?.remoteMediaClient?.add(self)
    let mediaInfo = ChromeCastController.shared.buildMediaInfo(from: workout)
    GCKCastContext.sharedInstance().presentDefaultExpandedMediaControls()
    loadItem(with: mediaInfo)
  }
  
  /**
   * Loads a media item in the current cast media session.
   - Parameter mediaInfo: The GCKMediaInformation Item for the video to load
   */
  func loadItem(with mediaInfo: GCKMediaInformation) {
    if let remoteMediaClient = GCKCastContext.sharedInstance().sessionManager.currentCastSession?.remoteMediaClient {
//      guard remoteMediaClient.mediaStatus != nil else { return }
      let request = remoteMediaClient.loadMedia(mediaInfo)
      request.delegate = self
    }
  }
  
  func switchToLocalPlayback(){
    guard playbackMode != .none else { return }
    castSession?.remoteMediaClient?.remove(self)
    castButton = nil
    playbackMode = .none
  }
  
  //  func playVideoRemotely(){
  //    guard let castSession = castSession else { print("No Current Cast Session") ; return }
  //
  //    castSession.remoteMediaClient?.loadMedia(buildMediaInfo(from: workout!))
  //
  //    Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { (_) in
  //      GCKCastContext.sharedInstance().presentDefaultExpandedMediaControls()
  //    }
  //  }
}

extension AtHomeWorkoutDetailTableViewController {
  
  /**
   Presents instructions for Google Cast the first time a chromecast device is availabe to this ViewController of the app
   */
//  @objc func castDeviceDidChange(_: Notification) {
//    if GCKCastContext.sharedInstance().castState != .noDevicesAvailable {
//      GCKCastContext.sharedInstance().presentCastInstructionsViewControllerOnce(with: castButton)
//    }
//  }
}
