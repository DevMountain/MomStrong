//
//  VideoPlayerView.swift
//  MomStrong
//
//  Created by DevMountain on 12/7/18.
//  Copyright © 2018 trevorAdcock. All rights reserved.
//

import UIKit
import AVKit

class VideoPlayerView: UIView {
    
    var videoUrlString: String?{
        didSet{
//            runVideo()
        }
    }
    
    var thumbNail: UIImage?{
        didSet{
            setThumbNail()
        }
    }
    
    weak var viewController: UIViewController?
    
    var thumbNailImageView: UIImageView!
    var playButton: UIButton!
    
    func runVideo(){
        guard let videoUrlString = videoUrlString, let url = URL(string: videoUrlString) else {return}
        hideThumbnailView()
        player = AVPlayer(url: url)
        player?.play()
        player?.volume = 0.5
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(playerItemDidReachEnd(notification:)),
                                               name: Notification.Name.AVPlayerItemDidPlayToEndTime,
                                               object: player?.currentItem)
    }
    
    func setThumbNail(){
        guard let thumbNail = thumbNail else { return }
        thumbNailImageView.image = thumbNail
    }
    
    func buildThumbnailImageView(){
        self.thumbNailImageView = UIImageView(frame: self.bounds)
        self.addSubview(thumbNailImageView)
    }
    
    func hideThumbnailView(){
        thumbNailImageView.isHidden = true
        playButton.isHidden = true
    }
    
    func buildPlayButton(){
        let frame = CGRect(x: 0, y: 0, width: self.frame.width/2, height: self.frame.height/2)
        
        playButton = UIButton(frame: frame)
        playButton.imageView?.image = #imageLiteral(resourceName: "PlayButton")
        self.addSubview(playButton)
        playButton.center = self.center
    }
    
    var playerLayer: AVPlayerLayer{
        return layer as! AVPlayerLayer
    }
    
    var player: AVPlayer? {
        get{
            return playerLayer.player
        }
        set{
            playerLayer.player = newValue
        }
    }
    
    override class var layerClass: AnyClass{
        return AVPlayerLayer.self
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        buildThumbnailImageView()
        let tap = UITapGestureRecognizer(target: self, action: #selector(wasTapped))
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(wasDoubleTapped))
        
        doubleTap.numberOfTapsRequired = 2
        tap.require(toFail: doubleTap)
        
        addGestureRecognizer(tap)
        addGestureRecognizer(doubleTap)
        
        player?.volume = 0
        
    }
    
    @objc func wasTapped(){
        player?.timeControlStatus.rawValue == 0 ? player?.play() : player?.pause()
    }
    
    @objc func wasDoubleTapped(){
        guard let player = player else { return }
        viewController?.presentAVPlayerVC(with: player)
    }
    
    @objc func playerItemDidReachEnd(notification: Notification) {
        if let playerItem: AVPlayerItem = notification.object as? AVPlayerItem {
            playerItem.seek(to: CMTime.zero) { (_) in
                self.player?.play()
            }
        }
    }
}
