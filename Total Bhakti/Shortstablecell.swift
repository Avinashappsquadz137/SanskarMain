//
//  Shortstablecell.swift
//  Sanskar
//
//  Created by Surya on 14/07/23.
//  Copyright © 2023 MAC MINI. All rights reserved.
//

import UIKit
import AVKit


class Shortstablecell: UITableViewCell {
    
    @IBOutlet weak var playerview: UIView!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var playcontrol: UIView!
//    @IBOutlet weak var discrptionview1: UIView!
//    @IBOutlet weak var discrptionlbl1: UILabel!
    @IBOutlet weak var sharebtn:UIButton!
    @IBOutlet weak var shareview:UIView!
    @IBOutlet weak var userlikebtn:UIButton!
    @IBOutlet weak var usercommentbtn:UIButton!
    @IBOutlet weak var likecount:UILabel!
    @IBOutlet weak var commentcount:UILabel!
    @IBOutlet weak var sharecount:UILabel!
    
    
    
    var player: AVPlayer?
    var playerLayer: AVPlayerLayer?
    var observer: Any?
    var status: Int = 0
    //
    override func awakeFromNib() {
           super.awakeFromNib()
       }
    
    func updateCommentCount(_ count: String) {
            commentcount.text = count
        }
    
       override func prepareForReuse() {
           super.prepareForReuse()
           resetPlayer()
       }

       func resetPlayer() {
           player?.pause()
           playerLayer?.removeFromSuperlayer()

           if let observer = observer {
               NotificationCenter.default.removeObserver(observer)
           }

           observer = nil
       }

       func configureCell(with videoURLString: String) {
           resetPlayer()

           guard let videoURL = URL(string: videoURLString) else {
               // Handle invalid URL case
               return
           }

           player = AVPlayer(url: videoURL)
           playerLayer = AVPlayerLayer(player: player)
           playerLayer?.frame = bounds
           playerLayer?.videoGravity = .resize

           layer.addSublayer(playerLayer!)
           playerLayer?.addSublayer(playcontrol.layer)
        //   playerLayer?.addSublayer(discrptionview1.layer)
           playerLayer?.addSublayer(shareview.layer)

           observer = NotificationCenter.default.addObserver(
               forName: .AVPlayerItemDidPlayToEndTime,
               object: player?.currentItem,
               queue: nil,
               using: { [weak self] _ in
                   self?.restartVideo()
               }
           )
       }

       func restartVideo() {
           player?.seek(to: kCMTimeZero)
           player?.play()
       }
    
    @IBAction func playPauseButtonTapped(_ sender: UIButton){
        
        if let player = player {
                  if player.rate == 0 {
                      // Player is paused, so play
                      player.play()
                      playPauseButton.setImage(UIImage(named: ""), for: .normal)
                  } else {
                      // Player is playing, so pause
                      player.pause()
                      playPauseButton.setImage(UIImage(named: "shortsplay"), for: .normal)
                  }
              }
    }

    
 
    
}
