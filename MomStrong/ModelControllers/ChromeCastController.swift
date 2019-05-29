//
//  ChromeCastController.swift
//  MomStrong
//
//  Created by DevMountain on 12/7/18.
//  Copyright © 2018 trevorAdcock. All rights reserved.
//

import Foundation
import GoogleCast

class ChromeCastController{
  
  static let shared = ChromeCastController()
  
  var playbackMode: PlaybackMode = .none
  
  var sessionManager: GCKSessionManager{
    return GCKCastContext.sharedInstance().sessionManager
  }
  
  
  func buildMediaInfo(from workout: Workout) -> GCKMediaInformation{
    let metaData = buildMediaMetaData(workout: workout)
    print(workout.videoUrl!)
    let mediaInfo = GCKMediaInformation(contentID: workout.videoUrl!, streamType: .unknown, contentType: "video/mp4", metadata: metaData, adBreaks: nil, adBreakClips: nil, streamDuration: 20.0*60.0, mediaTracks: nil, textTrackStyle: nil, customData: nil)
    return mediaInfo
  }
  
  func buildMediaMetaData(workout: Workout) -> GCKMediaMetadata{
    let metaData = GCKMediaMetadata(metadataType: .movie)
    metaData.setString(workout.title, forKey: kGCKMetadataKeyTitle)
    metaData.setString(workout.description, forKey: kGCKMetadataKeySubtitle)
    if let thumbnailUrl = URL(string: workout.thumbnailUrl ?? ""){
      let gckThumbnail = GCKImage(url: thumbnailUrl, width: 100, height: 100)
      metaData.addImage(gckThumbnail)
    }
    return metaData
  }
}

enum PlaybackMode: Int {
  case none = 0
  case local
  case remote
}
