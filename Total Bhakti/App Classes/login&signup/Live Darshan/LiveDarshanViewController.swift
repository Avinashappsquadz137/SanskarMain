//
//  LiveDarshanViewController.swift
//  Sanskar
//
//  Created by Sanskar IOS Dev on 27/11/24.
//  Copyright © 2024 MAC MINI. All rights reserved.
//
import UIKit
import AVKit
import AVFoundation
import SDWebImage

import YouTubePlayer

@available(iOS 13.0, *)
class LiveDarshanViewController: UIViewController {
   
    @IBOutlet weak var videoPlayer: UIView!
    @IBOutlet weak var playerYoutube: YouTubePlayerView!
    @IBOutlet weak var headerHeight: NSLayoutConstraint!
     
    var darshanList : String = ""
    var vdotype : String = ""
    
    lazy var mmPlayer: MMPlayerLayer = {
        let l = MMPlayerLayer()
        
        l.cacheType = .memory(count: 5)
        l.coverFitType = .fitToPlayerView
        l.videoGravity = AVLayerVideoGravity.resizeAspect
        l.replace(cover: CoverA.instantiateFromNib())
        return l
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        seupUI()

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        playerYoutube.isHidden = true
        playerYoutube.pause()
        videoPlayer.isHidden = true
        TV_PlayerHelper.shared.mmPlayer.player?.pause()
        TV_PlayerHelper.shared.mmPlayer.isHidden = false
        TV_PlayerHelper.shared.mmPlayer.player?.replaceCurrentItem(with: nil)
    }
    
    @IBAction func bckBtn(_ sender: UIButton) {
        playerYoutube.isHidden = true
        playerYoutube.pause()
        videoPlayer.isHidden = true
        TV_PlayerHelper.shared.mmPlayer.player?.pause()
        TV_PlayerHelper.shared.mmPlayer.isHidden = false
        TV_PlayerHelper.shared.mmPlayer.player?.replaceCurrentItem(with: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    func seupUI(){
        if vdotype == "0"{
            uiUpdateYouTube()
        }else {
            uiUpdateCustomPlayer()
        }
    }
    
    
    func uiUpdateYouTube() {
        videoPlayer.isHidden = true
        playerYoutube.isHidden = false
        if let videoID = darshanList.components(separatedBy: "/").last {
            print("Video ID: \(videoID)")
        playerYoutube.delegate = self
        playerYoutube.playerVars = (["playsinline": 1,"controls":1,"modestbranding":1] as AnyObject) as! YouTubePlayerView.YouTubePlayerParameters
        playerYoutube.loadVideoID(videoID)
        playerYoutube.contentMode = .scaleToFill
        playerYoutube.isHidden = false
    }
    }
    
    func uiUpdateCustomPlayer(){
        videoPlayer.isHidden = false
        playerYoutube.isHidden = true
        let videoURL : URL?
        if darshanList != ""{
            videoURL = URL(string: darshanList)
            playVideo(url:videoURL!)
        }
    }
    
    func playVideo(url: URL){
        TV_PlayerHelper.shared.mmPlayer.isHidden = false
        TV_PlayerHelper.shared.mmPlayer.set(url: url)
        TV_PlayerHelper.shared.mmPlayer.playView = videoPlayer
        TV_PlayerHelper.shared.mmPlayer.resume()
        TV_PlayerHelper.shared.mmPlayer.setCoverView(enable: true)
        TV_PlayerHelper.shared.mmPlayer.player?.play()
        TV_PlayerHelper.shared.mmPlayer.resume()
        TV_PlayerHelper.shared.mmPlayer.setCoverView(enable: true)
        TV_PlayerHelper.shared.mmPlayer.player?.allowsExternalPlayback = true
        TV_PlayerHelper.shared.mmPlayer.player?.usesExternalPlaybackWhileExternalScreenIsActive = true
        TV_PlayerHelper.shared.mmPlayer.player?.usesExternalPlaybackWhileExternalScreenIsActive = true
    }


}

@available(iOS 13.0, *)
extension LiveDarshanViewController: YouTubePlayerDelegate {
    func playerReady(_ videoPlayer: YouTubePlayer.YouTubePlayerView) {
        playerYoutube.play()
    }
}
