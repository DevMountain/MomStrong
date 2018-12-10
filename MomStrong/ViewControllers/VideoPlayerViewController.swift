//
//  VideoPlayerViewController.swift
//  MomStrong
//
//  Created by DevMountain on 12/4/18.
//  Copyright © 2018 trevorAdcock. All rights reserved.
//

import UIKit
import AVKit

class VideoPlayerViewController: AVPlayerViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: "https://player.vimeo.com/external/303939659.sd.mp4?s=37b11800704d7db8e5ac45e600adbb0124164a47&profile_id=165&oauth2_token_id=1147496118")!
        self.player = AVPlayer(url: url)
        self.tabBarController?.tabBar.isHidden = true
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
