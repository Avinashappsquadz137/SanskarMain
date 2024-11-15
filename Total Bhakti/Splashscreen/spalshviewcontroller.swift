//
//  spalshviewcontroller.swift
//  Sanskar
//
//  Created by Sanskar IOS Dev on 10/06/24.
//  Copyright © 2024 MAC MINI. All rights reserved.
//
import UIKit
import AVFoundation

class splashviewcontroller: UIViewController {
    var player: AVPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

      
    }
    
    override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            
            if let path = Bundle.main.path(forResource: "sanskarlogo", ofType: "mp4") {
                let url = URL(fileURLWithPath: path)
                player = AVPlayer(url: url)
                let layer = AVPlayerLayer(player: player)
                layer.frame = view.bounds
                layer.videoGravity = .resizeAspectFill
                view.layer.addSublayer(layer)
                player?.volume = 0
                player?.play()
                
                // Add observer for when the video finishes playing
               NotificationCenter.default.addObserver(self, selector: #selector(videoDidFinish), name: .AVPlayerItemDidPlayToEndTime, object: player?.currentItem)
                
            } else {
                print("File not found: sanskarlogo.mp4")
                // Handle the error, e.g., show an alert to the user
            }
        }
    // Selector method called when the video finishes playing
      @objc func videoDidFinish(notification: Notification) {
          // Remove observer
          NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: nil)
 
          UIViewController().navigatToHomeScreen()
      }
  }


  


