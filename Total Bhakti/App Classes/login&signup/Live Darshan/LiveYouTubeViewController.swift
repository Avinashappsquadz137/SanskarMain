//
//  LiveYouTubeViewController.swift
//  Sanskar
//
//  Created by Sanskar IOS Dev on 28/11/24.
//  Copyright © 2024 MAC MINI. All rights reserved.
//

import UIKit
import YouTubePlayer
import YoutubePlayer_in_WKWebView

class LiveYouTubeViewController: UIViewController , YouTubePlayerDelegate{
    
    
    @IBOutlet weak var videPlayer: WKYTPlayerView!
    @IBOutlet weak var mainViderplayer: UIView!
    
    
    var playerCurrentTime: Float = 0.0
    var videodata: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupVideoPlayer()
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        videPlayer.stopVideo()
    }
    
    @IBAction func bckBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func setupVideoPlayer() {
        videPlayer.delegate = self
        print(videodata ?? "")
        if let videoID = videodata?.components(separatedBy: "/").last {
            print("Video ID: \(videoID)")
            videPlayer.load(withVideoId: videoID)
            
        }
    }
    
}

extension LiveYouTubeViewController: WKYTPlayerViewDelegate {
    
    func playerViewDidBecomeReady(_ playerView: WKYTPlayerView) {
        videPlayer.playVideo()
    }
    
    func playerView(_ playerView: WKYTPlayerView, didPlayTime playTime: Float) {
        self.playerCurrentTime = playTime
    }
    
    func playerView(_ playerView: WKYTPlayerView, didChangeTo state: WKYTPlayerState) {
        switch state {
        case .ended:
            print("Video end.")
        case .playing:
            print("Video started playing.")
        case .paused:
            print("Video paused.")
        default:
            print("Player state changed: \(state)")
        }
    }
    
    func playerView(_ playerView: WKYTPlayerView, receivedError error: WKYTPlayerError) {
        print("Player received an error: \(error)")
    }
    
    func playerView(_ playerView: WKYTPlayerView, didChangeTo quality: WKYTPlaybackQuality) {
        print("Playback quality changed to: \(quality)")
    }
    
}
