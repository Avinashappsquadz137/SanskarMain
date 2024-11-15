//
//  TV_PlayerHelper.swift
//  Sanskar
//
//  Created by mac on 01/07/20.
//  Copyright © 2020 MAC MINI. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation


class TV_PlayerHelper:NSObject{
    
    static let shared = TV_PlayerHelper()
    
     var mmPlayer: MMPlayerLayer = {
        let l = MMPlayerLayer()
        l.cacheType = .memory(count: 5)
        l.coverFitType = .fitToPlayerView
        l.videoGravity = AVLayerVideoGravity.resizeAspect
        l.replace(cover: CoverA.instantiateFromNib())
//        l.setOrientation(.protrait)
        l.fullScreenWhenLandscape = true
        return l
    }()
    
    

}
