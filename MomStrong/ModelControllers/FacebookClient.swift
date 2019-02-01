//
//  FacebookClient.swift
//  MomStrong
//
//  Created by DevMountain on 1/31/19.
//  Copyright © 2019 trevorAdcock. All rights reserved.
//

import Foundation
import FBSDKCoreKit

class FacebookClient {
  
  static let currentUser = UserController.shared.currentUser

  static func loggedInEvent() {
    guard let user = currentUser else { return }
    FBSDKAppEvents.logEvent("User Logged In", parameters: ["\(user.id)" : user.name])
  }
  
  static func watchedContentEvent(){
    guard let user = currentUser else { return }
    FBSDKAppEvents.logEvent("User Watched Content", parameters: ["\(user.id)" : user.name])
  }
}
