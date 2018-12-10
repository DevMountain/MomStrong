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
    
    var sessionManager: GCKSessionManager{
        return GCKCastContext.sharedInstance().sessionManager
    }
    
//    let mediaInfo = GCKMediaInformation(contentID: <#T##String#>, streamType: <#T##GCKMediaStreamType#>, contentType: <#T##String#>, metadata: <#T##GCKMediaMetadata?#>, adBreaks: <#T##[GCKAdBreakInfo]?#>, adBreakClips: <#T##[GCKAdBreakClipInfo]?#>, streamDuration: <#T##TimeInterval#>, mediaTracks: <#T##[GCKMediaTrack]?#>, textTrackStyle: <#T##GCKMediaTextTrackStyle?#>, customData: <#T##Any?#>)
//    
}
