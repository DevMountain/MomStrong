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
    
    
    @IBOutlet weak var videoPlayerView: VideoPlayerView!
    @IBOutlet weak var titleLabel: UILabel!
    
    let castMediaController = GCKUIMediaController()
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavHeaderView()
        let frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        let castButton = GCKUICastButton(frame: frame)
        castButton.tintColor = UIColor.powerMomRed
        let barButton = UIBarButtonItem(customView: castButton)
        navigationItem.rightBarButtonItem = barButton
        sessionManager.add(self)
//        castButton.addTarget(self, action: #selector(chromeCast), for: .allEvents)
//        videoPlayerView.viewController = self
    }
    
    @objc func chromeCast(){
        guard let workout = workout else { return }
        let mediaInfo = buildMediaInfo(from: workout)
        castSession?.remoteMediaClient?.loadMedia(mediaInfo)
        GCKCastContext.sharedInstance().presentDefaultExpandedMediaControls()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workout?.circuits.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "workoutSectionCell", for: indexPath) as? WorkoutSectionTableViewCell
        cell?.workoutSection = workout?.circuits[indexPath.row]
        return cell ?? UITableViewCell()
    }
    
    func updateViews(){
        titleLabel.text = workout?.title
        videoPlayerView.videoUrlString = workout?.videoUrl
        videoPlayerView.thumbNail = workout?.thumbnail
        videoPlayerView.player?.play()
    }
}


extension AtHomeWorkoutDetailTableViewController: GCKSessionManagerListener {
    
    
    func sessionManager(_ sessionManager: GCKSessionManager, willStart session: GCKSession) {
        print("🥶 Session manager will Start 🥶")
        guard let workout = workout else { return }
//        let mediaInfo = buildMediaInfo(from: workout)
//        session.remoteMediaClient?.loadMedia(mediaInfo)
    }
    
    func sessionManager(_ sessionManager: GCKSessionManager, didStart session: GCKSession) {
        print("🥶 Session manager didStart 🥶")
        playVideoRemotely()
    }
    
    func sessionManager(_ sessionManager: GCKSessionManager, didResumeSession session: GCKSession) {
        print("🥶 Session manager didResumeSession 🥶")
        switchToRemotePlay()
    }
    
    func sessionManager(_ sessionManager: GCKSessionManager, didEnd session: GCKSession, withError error: Error?) {
        if let error = error {
            print("💩  There was an error in \(#function) ; \(error)  ; \(error.localizedDescription)  💩")
        }
        print("🥶 Session Manager Did End 🥶")
        switchToLocalPlayback()
    }
    
    func sessionManager(_ sessionManager: GCKSessionManager, didFailToStart session: GCKSession, withError error: Error) {
        print("🥶 Session manager did FailTOStart with error 🥶")
        print("💩  There was an error in \(#function) ; \(error)  ; \(error.localizedDescription)  💩")
    }
    
    func buildMediaInfo(from workout: Workout) -> GCKMediaInformation{
        let metaData = buildMediaMetaData(workout: workout)
        print(workout.videoUrl!)
        let mediaInfo = GCKMediaInformation(contentID: workout.videoUrl!, streamType: .unknown, contentType: "video/mp4", metadata: metaData, adBreaks: nil, adBreakClips: nil, streamDuration: Double(workout.duration ?? 20) * 60, mediaTracks: nil, textTrackStyle: nil, customData: nil)
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
    
    func switchToRemotePlay(){
        
    }
    
    func switchToLocalPlayback(){
        
    }
    
    func playVideoRemotely(){
        guard let castSession = castSession else { print("No Current Cast Session") ; return }
        castSession.remoteMediaClient?.loadMedia(buildMediaInfo(from: workout!))
    }
    
//    func pushToRemotePlayBack(){
//        print("pushing to remote playback")
//        
//        castSession?.remoteMediaClient?.queueLoad([], with: <#T##GCKMediaQueueLoadOptions#>)
//    }
}
