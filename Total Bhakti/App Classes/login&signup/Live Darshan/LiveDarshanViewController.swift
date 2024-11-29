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
import YoutubePlayer_in_WKWebView

@available(iOS 13.0, *)
class LiveDarshanViewController: UIViewController {
    
    @IBOutlet weak var videoPlayer: UIView!
    @IBOutlet weak var videoPlayerHeight: NSLayoutConstraint!
    
    @IBOutlet weak var headerHeight: NSLayoutConstraint!
    @IBOutlet weak var viewControll: UIView!
    @IBOutlet weak var stackCtrView: UIStackView!
    @IBOutlet weak var imgPlay: UIImageView! {
        didSet {
            self.imgPlay.isUserInteractionEnabled = true
            self.imgPlay.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTapPlayPause)))
        }
    }
    @IBOutlet weak var imgLive: UIImageView!
    @IBOutlet weak var seekSlider: UISlider!
    @IBOutlet weak var imgFullScreenToggle: UIImageView! {
        didSet {
            self.imgFullScreenToggle.isUserInteractionEnabled = true
            self.imgFullScreenToggle.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTapToggleScreen)))
        }
    }

    var darshanList : String = ""
    private var player : AVPlayer? = nil
    private var playerLayer : AVPlayerLayer? = nil
    private var pipController: AVPictureInPictureController?
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.setVideoPlayer()
    
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.player?.pause()
    }
    
    @IBAction func bckBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func setVideoPlayer() {
        guard let url = URL(string: darshanList) else { return }
        
        if self.player == nil {
            self.player = AVPlayer(url: url)
            self.playerLayer = AVPlayerLayer(player: self.player)
            self.playerLayer?.videoGravity = .resize
            self.playerLayer?.frame = self.videoPlayer.frame
            self.playerLayer?.addSublayer(self.viewControll.layer)
            if let playerLayer = self.playerLayer {
                self.view.layer.addSublayer(playerLayer)
            }
            self.player?.play()
            self.liveimage()
            self.setupPiP()
        }
    }
    
    private var windowInterface : UIInterfaceOrientation? {
        return self.view.window?.windowScene?.interfaceOrientation
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        guard let windowInterface = self.windowInterface else { return }
        if windowInterface.isPortrait ==  true {
            self.videoPlayerHeight.constant = 250
            self.headerHeight.constant = 60
        } else {
            self.videoPlayerHeight.constant = self.view.layer.frame.width
            self.headerHeight.constant = 0
        }
        print(self.videoPlayerHeight.constant)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            self.playerLayer?.frame = self.videoPlayer.frame
        })
    }
    private func setupPiP() {
           guard let playerLayer = playerLayer else { return }
           if AVPictureInPictureController.isPictureInPictureSupported() {
               pipController = AVPictureInPictureController(playerLayer: playerLayer)
               pipController?.delegate = self
           } else {
               print("Picture in Picture is not supported on this device.")
           }
       }
    
    private func liveimage() {
        let gifName: String = "live"
        if let gifPath = Bundle.main.path(forResource: gifName, ofType: "gif") {
            let gifURL = URL(fileURLWithPath: gifPath)
            imgLive.sd_setImage(with: gifURL)
        }
    }
    
    @objc private func onTapPlayPause() {
        if self.player?.timeControlStatus == .playing {
            self.imgPlay.image = UIImage(systemName: "pause.circle")
            self.player?.pause()
        } else {
            self.imgPlay.image = UIImage(systemName: "play.circle")
            self.player?.play()
        }
    }
    
    
    @objc private func onTapToggleScreen() {
        if #available(iOS 16.0, *) {
            guard let windowSceen = self.view.window?.windowScene else { return }
            if windowSceen.interfaceOrientation == .portrait {
                windowSceen.requestGeometryUpdate(.iOS(interfaceOrientations: .landscape)) { error in
                    print(error.localizedDescription)
                }
            } else {
                windowSceen.requestGeometryUpdate(.iOS(interfaceOrientations: .portrait)) { error in
                    print(error.localizedDescription)
                }
            }
        } else {
            if UIDevice.current.orientation == .portrait {
                let orientation = UIInterfaceOrientation.landscapeRight.rawValue
                UIDevice.current.setValue(orientation, forKey: "orientation")
            } else {
                let orientation = UIInterfaceOrientation.portrait.rawValue
                UIDevice.current.setValue(orientation, forKey: "orientation")
            }
        }
    }
}
@available(iOS 13.0, *)
extension LiveDarshanViewController: AVPictureInPictureControllerDelegate {
    func pictureInPictureControllerDidStartPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
        print("PiP Started")
    }
    
    func pictureInPictureControllerDidStopPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
        print("PiP Stopped")
    }
    
    func picture(_ pictureInPictureController: AVPictureInPictureController, failedToStartPictureInPictureWithError error: Error) {
        print("Failed to start PiP: \(error.localizedDescription)")
    }
    
    func picture(_ pictureInPictureController: AVPictureInPictureController, restoreUserInterfaceForPictureInPictureStopWithCompletionHandler completionHandler: @escaping (Bool) -> Void) {
        // Restore the UI if needed
        completionHandler(true)
    }
}
