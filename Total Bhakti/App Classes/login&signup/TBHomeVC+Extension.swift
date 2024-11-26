//
//  TBHomeVC+Extension.swift
//  Sanskar
//
//  Created by Sanskar IOS Dev on 26/11/24.
//  Copyright © 2024 MAC MINI. All rights reserved.
//

import Foundation
import AVFoundation
import AVKit

extension TBHomeVC : AVPictureInPictureControllerDelegate  {
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
    func setupPiP() {

        if AVPictureInPictureController.isPictureInPictureSupported() {
            pipController = AVPictureInPictureController(playerLayer: TV_PlayerHelper.shared.mmPlayer)
            pipController?.delegate = self
            print("Picture 55")
        } else {
            print("Picture in Picture is not supported on this device.")
        }
    }

}
