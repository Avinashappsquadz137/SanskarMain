//
//  TBPremiumSliderCell.swift
//  Sanskar
//
//  Created by Shouaib Ahmed on 15/04/21.
//  Copyright © 2021 MAC MINI. All rights reserved.
//

import UIKit
import AVFoundation
import YouTubePlayer

class TBPremiumSliderCell: UICollectionViewCell {
    
    @IBOutlet weak var sliderImg: UIImageView!
    @IBOutlet weak var sliderVideoView: UIView!
    
    var avQueuePlayer: AVQueuePlayer?
    var avPlayerLayer: AVPlayerLayer?
    
    
    func addPlayer(for url: URL,image: String) {
        TV_PlayerHelper.shared.mmPlayer.set(url: url)
        TV_PlayerHelper.shared.mmPlayer.playView = sliderVideoView
        TV_PlayerHelper.shared.mmPlayer.resume()
        TV_PlayerHelper.shared.mmPlayer.setCoverView(enable: true)
        TV_PlayerHelper.shared.mmPlayer.player?.play()
        let url = URL(string: image)!
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url)
            DispatchQueue.main.async {
                TV_PlayerHelper.shared.mmPlayer.thumbImageView.image = UIImage(data: data!)
            }
        }
        
    }
}
