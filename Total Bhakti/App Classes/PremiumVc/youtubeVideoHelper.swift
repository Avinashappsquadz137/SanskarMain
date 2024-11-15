//
//  youtubeVideoHelper.swift
//  Sanskar
//
//  Created by Warln on 06/10/21.
//  Copyright © 2021 MAC MINI. All rights reserved.
//

import Foundation
import UIKit

import YoutubePlayer_in_WKWebView

class YoutubePlayerHelper: NSObject{

    enum YTState {
        case  kUnStarted, kPlaying, kPaused, kEnded
    }

    var ytVideoPlayerView: WKYTPlayerView!
    var blockPlayerStateChanged:((YTState)->())? = nil

    func loadVideo(playerView: UIView,strVideoUrl: String) {
        ytVideoPlayerView = (playerView as! WKYTPlayerView)
        ytVideoPlayerView.delegate = self
        let playerVars = [
            "controls": 1,
            "playsinline" : 0,
            //            "autoplay" : 1,
            //            "autohide" : 1,
            "rel" : 0,
            "showinfo" : 0,
            //            "modestbranding" : 1
        ]

        if let videoID = self.extractYoutubeIdFromLink(link: strVideoUrl) {
            let result = ytVideoPlayerView.load(withVideoId: videoID, playerVars: playerVars) //S094ZseEnEQ, 0gosur3db5I
            debugPrint(result)
        }
    }

    func stopVideo() {
        if ytVideoPlayerView != nil {
            ytVideoPlayerView.stopVideo()
        }
    }

    func playVideo() {
        if ytVideoPlayerView != nil {
            ytVideoPlayerView.playVideo()
        }
    }

    func pauseVideo() {
        if ytVideoPlayerView != nil {
            ytVideoPlayerView.pauseVideo()
        }
    }

    fileprivate func extractYoutubeIdFromLink(link: String) -> String? {
        let pattern = "((?<=(v  |V)/)|(?<=be/)|(?<=(\\?|\\&)v=)|(?<=embed/))([\\w-]++)"
        guard let regExp = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive) else {
            return nil
        }
        let nsLink = link as NSString
        let options = NSRegularExpression.MatchingOptions(rawValue: 0)
        let range = NSRange(location: 0, length: nsLink.length)
        let matches = regExp.matches(in: link as String, options:options, range:range)
        if let firstMatch = matches.first {
            return nsLink.substring(with: firstMatch.range)
        }
        return nil
    }

}

extension YoutubePlayerHelper: WKYTPlayerViewDelegate {
    func playerView(_ playerView: WKYTPlayerView, didChangeTo state: WKYTPlayerState) {
        var ytState: YTState = .kUnStarted
        switch (state) {
        case WKYTPlayerState.playing:
            debugPrint("Started playback")
            ytState = .kPlaying
            break
        case WKYTPlayerState.paused:
            debugPrint("Paused playback")
            ytState = .kPaused
            break
        case WKYTPlayerState.ended:
            debugPrint("ended playback")
            ytState = .kEnded
            break
        case WKYTPlayerState.buffering:
            debugPrint("ended buffering")
            ytState = .kPlaying
            break
        default:
            break
        }
        blockPlayerStateChanged?(ytState)
    }
    
    
}
